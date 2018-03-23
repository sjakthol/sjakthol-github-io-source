---
Title: cfn-execute-change-set
ProjectGroup: AWS
Repository: https://github.com/sjakthol/cfn-execute-change-set
Summary: |
  A tool for reviewing and executing AWS CloudFormation change sets.
Tags:
  - aws
  - cloudformation
  - nodejs
Date: 2017-09-10
---

`cfn-execute-change-set` is a command line utility for reviewing and executing
AWS CloudFormation change sets. The tool parses the output of AWS CLI `create-change-set`
command, prints out a summary of changes and executes the change set if so
instructed.

This utility requires Node.js and can be installed with npm:
```bash
npm install -g cfn-execute-change-set
```

## Links

* Package in NPM: https://www.npmjs.com/package/cfn-execute-change-set
