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

## Coverage completion

Completes coverage with unification and disjunction operators, default disjuncts, type aliases, embedded scalars, if clauses in comprehensions, top-level ellipsis, and bound expressions.
