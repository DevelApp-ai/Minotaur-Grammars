# OpenCypher

Minotaur grammar for OpenCypher, covering the core language subset.

## Syntax sketch

```
MATCH (u:User)-[:POSTED]->(p:Post)
WHERE u.active = true
RETURN u.name, count(p) AS posts
ORDER BY posts DESC LIMIT 10;
```

## AST validation goals

- returned variables are bound by MATCH/CREATE patterns
- relationship patterns have matching arrowheads
- SET assignments target bound variables

Implements issue #79.
