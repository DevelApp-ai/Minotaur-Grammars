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

## Extended coverage

Adds interfaces, sealed classes, companion objects, lateinit, value classes, suspend functions, subject-less when, annotations, and labeled breaks.
