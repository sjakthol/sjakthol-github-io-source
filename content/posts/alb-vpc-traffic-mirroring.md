---
Title: Debugging Application Load Balancer TLS Negotiation Errors with Amazon VPC Traffic Mirroring
Draft: false
Date: 2020-05-24
Tags:
- aws

---

I recently came across an [Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html) (ALB) that had started to report an increasing number of Client TLS Negotiation Errors.

![ALB ClientTLSNegotiationErrorCount](/images/alb-vpc-traffic-mirroring-cw-metrics.png)

If you have ever tried to determine the cause of these errors, you might know the ALB does not provide any detail on why these errors occur. Failed connection attempts are not even logged into the [ALB Access Logs](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html). The ALB just reports each failed connection by incrementing the `ClientTLSNegotiationErrorCount` metric in CloudWatch.

This is not optimal especially if your ALB serves a wide variety of clients. It might be very difficult to find the exact client and client configuration that triggers the error. Additionally, the ALB is a fully managed service. So, you cannot just go in and poke at it to see how exactly are TLS connections failing.

Fortunately, a year ago, AWS released a new feature, [VPC Traffic Mirroring](https://docs.aws.amazon.com/vpc/latest/mirroring/what-is-traffic-mirroring.html), that allows you to capture and inspect network traffic within your own VPC. VPC Traffic Mirroring allows you to mirror network traffic from an [Elastic Network Interface](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-eni.html) (ENI) to another ENI (or a Network Load Balancer).

Now, under the hood, an ALB is just a fleet of AWS managed EC2 instances. These instances attach an ENI into your VPC through which all network traffic between the clients, targets and the ALB flows. Therefore, it should be possible to mirror network traffic of an ALB, and capture TLS handshakes for analysis.

## Setting up VPC Traffic Mirroring

You'll need to configure the following to mirror network traffic in a VPC:

* **Source**: An ENI of an EC2 Nitro instance from which packets are mirrored from.
* **Target**: An ENI of an EC2 instance or a NLB to which packets are mirrored to.
* **Mirror Filter**: A set of rules that define which packets are mirrored.
* **Mirror Session**: Definition for how to mirror traffic from a **Source** into **Target** and which **Mirror Filters** are used.

![ENI of an ALB](/images/alb-vpc-traffic-mirroring-alb-eni.png)

In our case, the source will be an ENI of the ALB and the target will be an EC2 instance we have access to. Since we want to debug client - ALB connections, we need to setup a mirror filter that only captures those packets. Remember, the ALB uses the same ENI to communicate with the clients in the internet and with the targets in the VPC. Since we are only interested in the traffic between the ALB and the clients, we can ignore traffic the ALB sends to the targets in the VPC.

#### Mirror Filters

A mirror filter contains filter rules that either accept or reject a package for mirroring. Filtering is based on layer 3 and layer 4 properties: source and destination IPs, source and destinations ports, L4 protocol (e.g. TCP, UDP), and the direction of the traffic.

In our case, we can achieve the desired outcome with the following rules (in this priority order):

1. Reject TCP ingress from `<VPC CIDR>`, source port 0-65535 to `<VPC CIDR>`, destination port 0-65535 (reject packets from targets to ALB).
2. Reject TCP egress from `<VPC CIDR>`, source port 0-65535 to `<VPC CIDR>`, destination port 0-65535 (reject packets from ALB to targets).
3. Accept TCP ingress from `0.0.0.0/0`, source port 0-65535 to `0.0.0.0/0`, destination port 443 (mirror packets from clients to ALB).
4. Accept TCP egress from `0.0.0.0/0`, source port 443 to `0.0.0.0/0`, destination port 0-65535 (mirror packets from ALB to clients).

Where `<VPC CIDR>` is the CIDR of the VPC. Filter rules are evaluated in order of their numeric priorities, and evaluation stops at the first matching rule. Hence, in our case, the priority of the reject rules must be higher than the priority of accept rules.

#### Mirror Session

With all the details sorted out, we can create a mirror session and start mirroring traffic from the ALB to our EC2 instance. However, you might receive the following error when doing this:

> NetworkInterfaceNotSupported: eni-xxxxxxxxxxxxxxxxx must be attached to a supported instance.

This error means that, under the hood, the ALB is using an EC2 instance that does not support traffic mirroring. Traffic mirroring is only supported for ENIs of instances using the AWS Nitro System (e.g. t3, m5, c5 and r5 instances). You cannot mirror traffic from an ENI that is attached to a non-Nitro instance (e.g. previous generation m4, c4 and r4 instances). Unfortunately, you cannot determine the instance type the ALB uses beforehand. The only way to see if mirroring is supported is to try it out.

If you happen to have an ALB that uses previous generation, non-Nitro instances, contact AWS Support. They should be able reconfigure your ALB to make it support traffic mirroring. If you are just testing this out, you should do the test on a newer region (like Europe (Stockholm) / `eu-north-1`). Newer regions lack previous generation instances which means all ALBs running on those regions use EC2 Nitro instances by default.

## Capturing Mirrored Traffic

Once the mirror session is created, VPC starts to mirror packets from the source ENI into the target ENI. VPC encapsulates mirrored packets with a [VXLAN header](https://tools.ietf.org/html/rfc7348) and sends them to the target ENI port 4789 over UDP. To capture the traffic, the target instance needs to 1) listen for UDP packets on port 4789, and 2) strip the VXLAN header from the received payloads.

You can use the following commands to create a new VXLAN interface to receive the mirrored traffic:
```
# ip link add capture0 type vxlan id 12345 local 10.0.0.83 remote 10.0.0.84 dev eth0 dstport 4789
# ip link set capture0 up
```

These commands create a new network interface, `capture0`, that receives traffic sent to `eth0` port `4789` with VXLAN ID `12345`. The VXLAN ID must match the VXLAN ID defined in the mirror session configuration.

You can now use `tcpdump` to see the mirrored traffic:

```
# tcpdump -n -i capture0 -vv
```

## Analyzing TLS Negotiation Errors

We now have the ability to see packets flowing between the ALB and the clients. We can use this ability to capture TLS handshakes and determine why they are failing.

Let's make `tcpdump` capture mirrored traffic and write them into a `pcap` file:

```
tcpdump -n -i capture0 -w capture.pcap
```

We can then load `capture.pcap` into e.g. [Wireshark](https://www.wireshark.org/) to analyze it. You can use the following filter to find TLS Alert Messages which indicate a failure during a TLS handshake:

```
tls.alert_message.level == 2
```

![TLS Alert Messages in Wireshark](/images/alb-vpc-traffic-mirroring-tls-errors.png)

In this (staged) example, we can see that the reason for the TLS Negotiation Errors is that the client does not trust the certificate (or the CA who signed the certificate) the ALB presents to it. With this information, we might be able to take some action to reduce the number of these errors.

----

Unfortunately, in the original case the clients were bailing out with a rather generic `bad_certificate` alert. [RFC 5246](https://tools.ietf.org/html/rfc5246) defines this alert message as

> A certificate was corrupt, contained signatures that did not verify correctly, etc.

which can mean pretty much anything (corruption on the wire, broken middlebox, misconfigured client etc.).

The source of errors in the original case remained a mystery even after trying to identify the clients by [fingerprinting their TLS ClientHellos](https://github.com/salesforce/ja3) (they all had the same fingerprint which indicates the errors were caused by a specific client version) and analyzing the source IPs of the failing connections (they were coming from many unique IPs from all over the world). Oh well, at least I learned some new tricks along the way.

If you want to try this at home, check out [sjakthol/aws-vpc-traffic-mirroring](https://github.com/sjakthol/aws-vpc-traffic-mirroring) repository in GitHub. The repository contains CloudFormation templates as well as instructions for setting up VPC traffic mirroring for your VPCs (and ALBs as well).

## Additional Links and References

* [VPC Traffic Mirroring](https://docs.aws.amazon.com/vpc/latest/mirroring/what-is-traffic-mirroring.html), AWS Documentation, AWS.
* [Troubleshooting AWS Environments Using Packet Captures](https://cloudshark.io/articles/aws-vpc-traffic-mirroring-cloud-packet-capture/), CloudShark.
