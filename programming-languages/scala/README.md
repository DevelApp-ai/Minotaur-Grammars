# Scala

Minotaur grammar for Scala, covering the core language subset.

## Syntax sketch

```
object MathUtils {
  def square(x: Int): Int = x * x

  def sum(xs: List[Int]): Int = xs match {
    case Nil => 0
    case h :: t => h + sum(t)
  }
}
```

## AST validation goals

- match expressions have cases
- def bodies are expressions or blocks
- case patterns bind identifiers

Implements issue #64.

## Coverage completion

The grammar now also covers the remaining core language constructs:

- `extension` method groups and `export` clauses
- Union (`|`) and intersection (`&`) types
- `opaque type` aliases
- `end` markers and `given ... with` instances
