---
Title: aws-dynamodb-copy
ProjectGroup: AWS
Repository: https://github.com/sjakthol/aws-dynamodb-copy
Summary: |
  A high-throughput utility for cloning data between two DynamoDB tables.
Tags:
  - aws
  - dynamodb
  - nodejs
Date: 2018-08-31
---

`aws-dynamodb-copy` is a simple script that allows you to copy the contents of
a DynamoDB table into another table on the same AWS region.

The script doesn't provide any fancy features. It scans the source table using
a [parallel scan](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Scan.html#Scan.ParallelScan)
and writes the items to the target tables in [batches](https://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_BatchWriteItem.html).
The rate at which items are copied can be tuned to suit the capacity allocated
to the target and source tables.

The script is able to provide a sustained rate of at least 10000 items copied
per second (running on an m5.large instance). Higher rates have not been tested.
