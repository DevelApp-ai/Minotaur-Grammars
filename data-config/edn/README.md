# EDN

Grammar for extensible data notation (EDN): lists, vectors, maps, sets, keywords, symbols, tags and scalar literals.

## Syntax sketch

```
{:key value, :nested {:k [1 2 3]}}
```

## AST validation goals

- Map entries must be key-value pairs (even arity)
- Duplicate map keys
- Duplicate set members
- Tagged-element handler resolution

Implements issue #32.
