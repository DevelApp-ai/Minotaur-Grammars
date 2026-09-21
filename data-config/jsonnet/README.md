# Jsonnet

Grammar for the Jsonnet configuration language: object/array comprehensions, local bindings, functions, imports and string interpolation.

## Syntax sketch

```
local x = 1; { a: x, b: [i for i in x] }
```

## AST validation goals

- Duplicate field names (no +: merge)
- Unbound variables in scope
- Comprehension variable shadowing
- Import path resolution
- self/$ usage outside objects

Implements issue #36.
