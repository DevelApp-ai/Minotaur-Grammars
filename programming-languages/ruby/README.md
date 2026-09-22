# Ruby

Minotaur grammar for Ruby, covering the core language subset.

## Syntax sketch

```
class Greeter
  def initialize(name)
    @name = name
  end

  def greet
    "Hello, #{@name}!"
  end
end
```

## AST validation goals

- if/while/class/def bodies are terminated by end
- method calls with blocks reference defined methods
- string interpolation is preserved in AST

Implements issue #57.

## Coverage completion

The grammar now also covers the remaining core language constructs:

- Stabby lambdas (`->(x) { ... }`)
- `refine` blocks for local monkey-patching
- `alias` / `alias_method` statements
- Heredocs (`<<~SQL ... SQL`)
- Percent literals (`%w[]`, `%i()`, `%q{}`, `%r{} `, `%s()`)
- Safe navigation (`&.`) and `defined?` checks
