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

## Extended coverage

Adds namespaces, interfaces, traits, try/catch/finally, switch, match expressions, arrow functions, instanceof, and static/const members.
