# Kotlin

Minotaur grammar for Kotlin, covering the core language subset.

## Syntax sketch

```
data class User(val name: String, val age: Int)

fun main() {
  val users = listOf(User("Ada", 36))
  users.forEach { u -> println(u.name) }
}
```

## AST validation goals

- val declarations are initialized
- when expressions are exhaustive or have else
- lambda parameters match usage

Implements issue #63.

## Coverage completion

The grammar now also covers the remaining core language constructs:

- `inline` functions with `reified` and `crossinline` type parameters
- `vararg`, `operator`, `infix`, and `tailrec` function modifiers
- `data object` declarations
- Implicit `it` lambdas
