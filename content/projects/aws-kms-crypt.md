---
Title: aws-kms-crypt
ProjectGroup: AWS
Repository: https://github.com/sjakthol/aws-kms-crypt
Summary: |
  A cross-language library for encrypting and decrypting secrets
  with the AWS KMS service. Includes support for Bash, Node.js and
  Python.
Tags:
  - aws
  - kms
  - bash
  - python
  - nodejs
Date: 2017-09-10
---

aws-kms-crypt is a cross-language utility for securing the confidentiality of
secrets and sensitive data in AWS. The key features of this tool are:

* Simple APIs for encrypting and decrypting sensitive data
* Interoperable implementations for multiple languages (Bash, Node and Python)
* [Envelope Encryption](https://docs.aws.amazon.com/kms/latest/developerguide/workflow.html) with `AES-128-CBC` and KMS generated data keys. That is, all secret data is encrypted locally and never sent to Amazon in plain text.

## Installation

* Node.js module in NPM: https://www.npmjs.com/package/aws-kms-crypt
* Python package in PyPi: https://pypi.python.org/pypi/aws-kms-crypt
* Shell script in Github: https://github.com/sjakthol/aws-kms-crypt/blob/master/shell/aws-kms-crypt.sh