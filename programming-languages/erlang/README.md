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

## Coverage completion

The grammar now also covers the remaining core language constructs:

- Bit syntax (`<<A:8, B/binary>>`) and map patterns
- Function specs and type declarations
- Preprocessor directives (`-ifdef`, `-define`, `-include`) and `catch`/`try` handling
