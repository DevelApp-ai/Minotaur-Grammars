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

## Extended coverage

Adds mixins, cascades, spread operators, null-aware access, factory and named constructors, getters/setters, typedefs, streams, and enhanced enums.
