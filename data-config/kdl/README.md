# KDL

Grammar for the KDL document language: nodes with arguments, properties, children blocks and type annotations.

## Syntax sketch

```
node "arg" prop=value { child-node }
```

## AST validation goals

- Duplicate property names within a node
- Child-block nesting depth
- Type-annotation validity
- Raw-string delimiter balance

Implements issue #31.
