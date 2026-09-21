# Dart

Minotaur grammar for Dart, covering the core language subset.

## Syntax sketch

```
class Greeter {
  final String name;
  Greeter(this.name);

  String greet() => 'Hello, $name!';
}
```

## AST validation goals

- final fields initialized via constructor this parameters
- async functions contain await only
- => functions are single expressions

Implements issue #65.

## Coverage completion

The grammar now also covers the remaining core language constructs:

- `extension` declarations
- Record types and record literals
- Pattern `switch` statements and `sealed` classes
- `async*` generators, `late` declarations, and `part` / `part of` directives
