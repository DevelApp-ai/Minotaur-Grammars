# Cue

Grammar for the CUE configuration language: packages, imports, fields, definitions, constraints, disjunctions and comprehensions.

## Syntax sketch

```
#Def: { name: string, port: int & >0 }
```

## AST validation goals

- Definition/reference resolution
- Constraint satisfiability (bounds, disjunctions)
- Duplicate field labels
- Optional field usage
- Comprehension variable scoping

Implements issue #37.

## Extended coverage

Adds definitions (`#Name`), hidden (`_field`) and optional (`field?`) fields, comprehensions, open structs (`...`), `let` clauses, imports, and string interpolation.
