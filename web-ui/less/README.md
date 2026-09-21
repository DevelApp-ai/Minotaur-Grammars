# LESS

Minotaur grammar for LESS, covering the core language subset.

## Syntax sketch

```
@base: 10px;

.rounded(@radius: 4px) {
  border-radius: @radius;
}

.box {
  padding: @base * 2;
  .rounded();
}
```

## AST validation goals

- @variables are declared before use
- mixin calls reference declared mixins
- arithmetic operations are well-formed

Implements issue #76.

## Extended coverage

Adds :extend, when guards, comparisons, namespaces, imports with options, escapes, and default guards.
