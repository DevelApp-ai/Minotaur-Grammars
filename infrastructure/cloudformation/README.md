# AWS CloudFormation

Grammar for AWS CloudFormation templates: Resources with types and properties, Parameters, Outputs, Mappings, Conditions and intrinsic functions.

## Syntax sketch

```
Resources:
  Name:
    Type: AWS::S3::Bucket
    Properties: { BucketName: b }
```

## AST validation goals

- Resource type validity
- Property names valid for the resource type
- Ref/GetAtt targets exist (parameters/resources)
- Condition references defined
- Output exports unique

Implements issue #39.
