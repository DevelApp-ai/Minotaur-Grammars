# R

Minotaur grammar for R, covering the core language subset.

## Syntax sketch

```
sum_squares <- function(x) {
  sum(x^2)
}

df$norm <- df$value / max(df$value)
```

## AST validation goals

- assignment operator is <- or =
- function default parameters are constants
- pipes/formulas preserved as AST nodes

Implements issue #68.

## Coverage completion

The grammar now also covers the remaining core language constructs:

- S4 object system (`setClass`, `setMethod`, `setGeneric`)
- Two-sided model formulas (`y ~ x`)
- Raw strings `r"(... )"` and additional pipe forms
