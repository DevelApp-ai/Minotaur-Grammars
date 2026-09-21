# INI

Grammar for INI configuration files: sections, key-value pairs, comments and inline values.

## Syntax sketch

```
[section]
key = value
```

## AST validation goals

- Duplicate keys within a section
- Duplicate section names
- Keys outside any section flagged
- Value type inference (number/bool/string)

Implements issue #30.

## Extended coverage

Adds comments, dotted (nested) keys, quoted values with escape sequences, line continuations, and value-less keys.
