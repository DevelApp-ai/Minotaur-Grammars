# HTML

Minotaur grammar for HTML, covering the core language subset.

## Syntax sketch

```
<!DOCTYPE html>
<html>
  <body>
    <h1 class="title">Hello</h1>
    <img src="logo.png" />
  </body>
</html>
```

## AST validation goals

- open tags have matching close tags (void elements excluded)
- attribute values are quoted
- document has a single html root

Implements issue #73.
