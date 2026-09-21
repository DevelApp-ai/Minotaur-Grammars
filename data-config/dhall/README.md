# Dhall

Grammar for the Dhall configuration language: let bindings, lambdas, records, unions, lists, imports and type annotations.

## Syntax sketch

```
let x : Natural = 1 in { a = x, b = True }
```

## AST validation goals

- Type annotation consistency
- Duplicate record labels
- Unbound let-variables
- Import path resolution

Implements issue #28.

## Extended coverage

Adds `toMap`, `assert`, `with` expressions, `Some`/`None` optional literals, builtin functions, double literals, and environment/remote/local imports.

## Coverage completion

Completes coverage with record/union punning, the application operator, list concatenation, more builtin functions, NaN/Infinity, and exponent-form doubles.
