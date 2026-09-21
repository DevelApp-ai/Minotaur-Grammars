# HOCON

Grammar for HOCON (Human-Optimized Config Object Notation): nested objects, key-value pairs, substitutions, arrays and includes.

## Syntax sketch

```
server { port = 8080, host = ${env.HOST} }
```

## AST validation goals

- Duplicate keys within the same object
- Substitution cycle detection
- Include file resolution
- Type consistency across merges

Implements issue #29.
