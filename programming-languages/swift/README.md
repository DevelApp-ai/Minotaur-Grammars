# Swift

Minotaur grammar for Swift, covering the core language subset.

## Syntax sketch

```
struct Point {
  let x: Double
  let y: Double

  func distance(to other: Point) -> Double {
    sqrt((x - other.x) * (x - other.x) + (y - other.y) * (y - other.y))
  }
}
```

## AST validation goals

- let declarations are initialized
- function return types match usage
- closures bind declared parameters

Implements issue #62.

## Extended coverage

Adds protocols, extensions, access control, computed properties and observers, defer, throwing functions with try/catch, generic where clauses, subscripts, and optional binding.
