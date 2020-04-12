---
Title: aws-s3-basic-auth
ProjectGroup: AWS
Repository: https://github.com/sjakthol/aws-s3-basic-auth
Description: |
  Protect access to S3 bucket with HTTP Basic Authentication. Powered by AWS
  CloudFront and Lambda@Edge.
Tags:
  - aws
  - s3
  - cloudfront
  - lambda
  - authentication
Date: 2017-11-12
---

The `aws-s3-basic-auth` project contains a setup for protecting access to S3
bucket with HTTP Basic Authentication.

The setup creates a CloudFront distribution for serving files from the target
bucket. A custom Lambda@Edge function is used to authenticate all requests
made to the CloudFront distribution. CloudFront authenticates itself to S3
using a custom Origin Access Identity which prevents direct access to the
contents of S3.

The entire setup can be deployed through CloudFormation to protect access
to any existing S3 bucket.

{{< rawhtml >}}
<a target="_blank" rel="noopener" href="https://github.com/sjakthol/aws-s3-basic-auth">View in Github</a>
{{< /rawhtml >}}