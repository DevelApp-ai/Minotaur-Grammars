# Haskell

Minotaur grammar for Haskell, covering the core language subset.

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

## Extended coverage

Adds type classes with functional dependencies, instances, newtype, where clauses, record constructors, hiding imports, operator sections, if/then/else, and list comprehensions.
