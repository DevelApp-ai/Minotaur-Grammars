# Erlang

Minotaur grammar for Erlang, covering the core language subset.

## Syntax sketch

```
-module(math_utils).
-export([square/1]).

square(X) -> X * X.

classify(X) when X > 0 -> positive;
classify(0) -> zero;
classify(_) -> negative.
```

## AST validation goals

- module attribute present exactly once
- exported functions have module/arity defined locally
- case clauses are ordered with a catch-all or are exhaustive

Implements issue #70.

## Extended coverage

Adds record declarations and usage, macros, list comprehensions, try/catch/after, behaviour declarations, map updates, and receive…after.
