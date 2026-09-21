# FlatBuffers

Grammar for FlatBuffers schema definition files: namespaces, tables, structs, enums, unions, attributes and RPC services.

## Syntax sketch

```
table Name { field: type = default (attr); }
```

## AST validation goals

- Struct fields must be scalar/struct only
- Enum default values in range
- Union member type existence
- Namespace/type reference resolution

Implements issue #33.
