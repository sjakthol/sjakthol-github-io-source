---
Title: cfn-monitor
ProjectGroup: AWS
Repository: https://github.com/sjakthol/cfn-monitor
Description: |
  A tool for monitoring the progress of AWS CloudFormation stack events
  during the creation or update of a stack.
Tags:
  - aws
  - cloudformation
  - nodejs
Date: 2017-09-10
---

`cfn-monitor` is a command line utility for monitoring the progress of CloudFormation
stack operations. The tool parses the output of the AWS CLI `create-stack` and
`update-stack` commands, listens for the stack events of the affected stacks and
prints them out to the terminal as they occur.

![Demo GIF](/images/cfn-monitor-demo.gif)

This utility requires Node.js and can be installed with npm:
```bash
npm install -g cfn-monitor
```

## Links

* Package in NPM: https://www.npmjs.com/package/cfn-monitor

{{< rawhtml >}}
<a target="_blank" rel="noopener" href="https://github.com/sjakthol/cfn-monitor">View in Github</a>
{{< /rawhtml >}}