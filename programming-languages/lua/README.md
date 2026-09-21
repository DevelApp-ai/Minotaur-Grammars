# Lua

Minotaur grammar for Lua, covering the core language subset.

## Syntax sketch

```
local function factorial(n)
  if n <= 1 then return 1 end
  return n * factorial(n - 1)
end
```

## AST validation goals

- if/while/for blocks terminated by end
- table constructors use consistent field syntax
- local declarations before use

Implements issue #66.
