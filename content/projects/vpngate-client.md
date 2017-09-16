---
Title: vpngate-client
ProjectGroup: Applications
Repository: https://github.com/sjakthol/vpngate-client
Summary: |
  A command line client for discovering and connecting to vpngate.net
  OpenVPN servers. Features include filtering VPNs by countries and
  geographic regions, built-in speed test of VPNs and iptables based
  blocking of connections that would bypass the VPN tunnel.
Tags:
    - python
Date: 2017-09-10
---

This tool can be used to connect to [vpngate.net](http://www.vpngate.net/en/)
OpenVPN servers from the command line. It has the following features:

* filter VPNs based on geographic restrictions
* filters out non-responsive VPNs
* performs a connection speed test for each candidate VPN
* blocks all VPN bypassing traffic with iptables

The application is written in python can and be used from most UNIX
systems that have Python and OpenVPN available.
