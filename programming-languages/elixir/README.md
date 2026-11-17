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

## Coverage completion

The grammar now also covers the remaining core language constructs:

- Multi-clause anonymous functions (`fn x -> ... end`)
- Bitstrings and binary comprehensions
- Sigils (`~s`, `~w`, `~r`, `~D`) and access syntax (`a[:k]`)
