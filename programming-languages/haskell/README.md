# Haskell

Minotaur grammar for Haskell 2010 core plus MultiWayIf/LambdaCase; lexing surface engine-verified (Conformance.txt + Examples.txt pin, GreedyLongestMatch).

## Syntax sketch

```
module MathUtils where

square :: Int -> Int
square x = x * x

sumList :: [Int] -> Int
sumList [] = 0
sumList (x:xs) = x + sumList xs
```

## AST validation goals

- every top-level func_decl has a type signature
- case alternatives are exhaustive over constructors
- do-blocks bind with <-

Implements issue #69.

## Coverage completion

The grammar now also covers the remaining core language constructs:

- `MultiWayIf`, `LambdaCase`, and `RecordWildCards` extensions
- Tuple sections and bang patterns
- Template Haskell splices and quasiquotes
