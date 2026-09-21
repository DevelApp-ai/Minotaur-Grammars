# Gremlin (Graph Traversal)

Minotaur grammar for Gremlin (Graph Traversal), covering the core language subset.

## Syntax sketch

```
g.V().hasLabel('person').has('age', gt(30))
  .out('knows').values('name').dedup().limit(10)
```

## AST validation goals

- traversal starts with a source step (g.V/g.E)
- step names are known Gremlin steps
- by modulators follow order/group/project steps

Implements issue #81.

## Coverage completion

The grammar now also covers the remaining language constructs:

- `with()` configuration steps and `sack()`
- `profile()` step
