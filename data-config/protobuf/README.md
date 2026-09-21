# Protobuf

Grammar for Protocol Buffers .proto files (proto3): packages, imports, messages, enums, oneofs, maps, services and options.

## Syntax sketch

```
message M { repeated string name = 1; }
```

## AST validation goals

- Field numbers unique within a message and in range
- Reserved numbers/names not reused
- Enum first value must be zero (proto3)
- Type reference resolution across packages/imports
- oneof fields without labels

Implements issue #35.

## Extended coverage

Adds `oneof`, `map` fields, `reserved`, services with streaming RPCs, nested messages, import modifiers, and package declarations.
