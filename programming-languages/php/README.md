# PHP

Minotaur grammar for PHP, covering the core language subset.

## Syntax sketch

```
<?php
class Calculator {
  public function add(int $a, int $b): int {
    return $a + $b;
  }
}
```

## AST validation goals

- every statement is terminated by ;
- method calls via -> reference class members
- type hints are valid identifiers

Implements issue #58.

## Coverage completion

The grammar now also covers the remaining core language constructs:

- Enums (pure and backed) with cases
- `readonly` classes and properties
- Attributes (`#[...]`)
- Nullsafe operator (`?->`) and null coalescing assignment (`??=`)
- First-class callable syntax (`strlen(...)`)
- `match` expressions
