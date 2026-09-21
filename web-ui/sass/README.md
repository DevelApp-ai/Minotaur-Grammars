# SASS/SCSS

Minotaur grammar for SASS/SCSS, covering the core language subset.

## Syntax sketch

```
$primary: #333;

@mixin border-radius($r) {
  border-radius: $r;
}

.button {
  color: $primary;
  @include border-radius(4px);
  &:hover { color: #fff; }
}
```

## AST validation goals

- variables are declared before use
- mixin includes reference declared mixins
- nested selectors use & parent references correctly

Implements issue #75.
