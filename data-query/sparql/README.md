# SPARQL

Minotaur grammar for SPARQL, covering the core language subset.

## Syntax sketch

```
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
SELECT ?name WHERE {
  ?person foaf:name ?name .
  FILTER (STRLEN(?name) > 3)
} LIMIT 10
```

## AST validation goals

- PREFIX declarations precede the query
- SELECT variables are bound in the graph pattern
- prefixed names use declared prefixes

Implements issue #80.

## Coverage completion

The grammar now also covers the remaining language constructs:

- `SERVICE` federated queries
- `FILTER NOT EXISTS` / `FILTER EXISTS`
- `GRAPH` clauses and property paths
