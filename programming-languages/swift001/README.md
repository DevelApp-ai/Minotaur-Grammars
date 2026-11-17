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

## Coverage completion

The grammar now also covers the remaining core language constructs:

- Actors and `async`/`await`/`throws` concurrency
- Property wrappers and result builders
- `deinit` blocks, `required` initializers
- `lazy` stored properties and `inout` parameters
