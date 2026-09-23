# YAML

Grammar for YAML documents: block and flow mappings and sequences, scalars (plain, quoted, block), anchors and aliases, tags, directives, comments and multi-document streams.

## Syntax sketch

```yaml
---
name: example
items:
  - one
  - two
nested: { a: 1, b: [x, y] }
```

## AST validation goals

- Duplicate keys within a mapping
- Block scalar indentation consistency
- Alias references resolving to a defined anchor
- Merge keys (<<) expanding to valid mapping targets
- Tag validity for built-in (!!str, !!int, !!seq, !!map, ...)

Implements issue #180.

## Coverage completion

Completes coverage with explicit keys (?), explicit document markers, directives (%YAML, %TAG, reserved), set syntax, null/boolean/number/timestamp scalars, and escape sequences.
