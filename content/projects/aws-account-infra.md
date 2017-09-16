---
Title: aws-account-infra
ProjectGroup: AWS
Repository: https://github.com/sjakthol/aws-account-infra
Summary: |
  CloudFormation templates for setting up an infrastructure for an AWS
  account. This includes configurations for CloudTrail, IAM, KMS and VPC.
Tags:
  - aws
  - cloudformation
Date: 2017-09-10
---

This projects contains an opinionated set of CloudFormation templates for an
AWS infrastructure setup that contains the following components:

* CloudTrail audit log saved to Amazon S3 for long-term storage.
* IAM roles, policies, groups and users with MFA required for all access to AWS
  resources.
* KMS key for encrypting sensitive data.
* VPC with route tables that provide varying level of access to / from the
  public internet over IPv4 and IPv6.
