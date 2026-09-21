# Avro

Grammar for Avro schema (avsc) definitions: record types with fields, enums, arrays, maps, fixed types, logical types and default values.

## Syntax sketch

```
{"type":"record","name":"N","fields":[{"name":"f","type":"string"}]}
```

## AST validation goals

- Duplicate field names within a record
- Default value type matches field type
- Named-type reference resolution (incl. namespaces)
- Enum symbol uniqueness
- Fixed size positive integer

Implements issue #34.

## Coverage completion

Completes coverage with namespace, nested record definitions, bytes/decimal with precision and scale, error types, protocol definitions, and a full JSON value rule.
