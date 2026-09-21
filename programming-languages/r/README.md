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

## Extended coverage

Adds the native pipe `|>`, `%in%`, repeat loops, switch, tryCatch, S3 class names, the apply family, double-bracket indexing, and `:` sequences.
