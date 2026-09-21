# Elixir

Minotaur grammar for Elixir, covering the core language subset.

## Syntax sketch

```
defmodule MathUtils do
  def square(x), do: x * x

  def classify(x) when x > 0, do: :positive
  def classify(0), do: :zero
  def classify(_), do: :negative
end
```

## AST validation goals

- defmodule blocks are terminated by end
- pipes pass the left value as first argument
- keyword lists use key: value form

Implements issue #71.

## Extended coverage

Adds alias/use/import, module attributes, structs, with statements, cond, try/rescue, for comprehensions, and protocols with implementations.
