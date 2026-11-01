# PowerShell

Minotaur grammar for PowerShell 7, covering the core language surface.

## Syntax sketch

```
param(
    [string]$Name
)
function Get-Greeting {
    Write-Output "Hello, $Name!"
}
Get-Greeting -Name 'World' > greetings.txt
```

## AST validation goals

- command invocation is a named command word followed by arguments
- named parameters are `-Name value` / `-Switch` tokens
- pipelines compose commands with `|`, `&&`, `||`
- redirection operators attach to pipeline statements
- variables carry scope/namespace qualifiers (`$env:PATH`, `$global:x`)

Authored for SBOB-Forge M5 Phase B (TDS 5.4): SBOB-Forge lifts behavior
(exec, open, egress, ingress) from PowerShell test suites (Pester) and
needs a pinned structural grammar for the language instead of a lexical
scanner.

## Modeled approximation

Here-string bodies (`@"` … `"@`) are approximated: the closing terminator
is only recognized after a newline, which plain EBNF cannot express, so
the body productions accept interior quote characters and stop at the
closing `"@`. Interpolation inside double-quoted strings and here-strings
is modeled structurally (`$var`, `$(…)`) but not interpolated.

## Coverage

- Scripts, statements, semicolon/backtick statement separators
- `using` (namespace/module/assembly), `param` blocks, attributes
- `function` / `filter` / `workflow`, classes (methods, properties,
  constructors, `hidden`/`static`), enums
- `if`/`elseif`/`else`, `switch` (with `-regex`/`-wildcard`/`-exact`/
  `-casesensitive`/`-file`/`-parallel` flags), `foreach`, `for`, `while`,
  `do`/`while`/`until`, `try`/`catch`/`finally`, `trap`, labels
- Pipelines (`|`, `&&`, `||`), call operators (`&`, `.`, `::`),
  redirection (`>`, `>>`, `<`, `2>&1`-family merges)
- Expressions: ternary, comparison/logical operators (`-eq` … `-join`),
  ranges, member access (`.`, `::`, `?.`), indexing, casts, `++`/`--`
- Arrays `@(…)`, hash literals `@{…}`, sub-expressions `$(…)`, script
  blocks, generic/array type literals
- Strings: single (with `''` escape), double (with backtick escapes and
  `$var`/`$(…)` interpolation), verbatim, here-strings
- Variables: scoped (`$global:`), namespaced (`$env:`), special (`$_`,
  `$?`, `$args`), braced `${…}`
- Comments: `#` and `<# … #>` (comment-based help)
