# Bash

Minotaur grammar for Bash 5 (POSIX shell superset), covering the core
language surface.

## Syntax sketch

```
#!/usr/bin/env bash
set -euo pipefail
greet() {
    local name="$1"
    printf 'Hello, %s!\n' "$name"
}
greet 'World' > greetings.txt
```

## AST validation goals

- a script is a list of complete commands (pipelines joined by
  `&&`, `||`, `;`, `&`)
- simple commands are assignments, a command word, arguments, and
  redirections
- expansions (`$var`, `${…}`, `$(…)`, `$((…))`, backticks) are
  distinguishable inside and outside double quotes
- compound commands (`if`, `for`, `case`, `[[ ]]`, `{ …; }`, `( … )`)
  nest full command lists
- here-documents bind a body to their delimiter word

Authored for SBOB-Forge M5 Phase B (TDS 5.4): SBOB-Forge lifts behavior
(exec, open, egress, ingress) from Bash test suites (Bats) and needs a
pinned structural grammar for the language instead of a lexical scanner.

## Modeled approximations

- Here-document bodies are approximated the same way as line-oriented
  content in other grammars: the closing delimiter is only recognized
  after a newline, which plain EBNF cannot express.
- Brace expansion (`{a,b}` / `{1..10}`) is modeled structurally without
  expanding the sequence.
- `case` patterns accept any word shape; glob semantics live in the
  consumer, not the grammar.

## Coverage

- Lists, pipelines, `!` negation, `|&`
- Simple commands: prefix assignments (incl. array indexes), command
  words, arguments
- Compound commands: `{ …; }`, `( … )`, `if`/`elif`/`else`/`fi`,
  `while`/`until`/`do`/`done`, `for` (word list and C-style `for ((…))`),
  `select`, `case` (with `;;`, `;&`, `;;&`), `[[ ]]`, `[ ]`, `(( ))`
- Function definitions (both `name() { … }` and `function name { … }`),
  `coproc`
- Redirections: `>`, `>>`, `<`, `<>`, `>&`, `<&`, `>|`, `&>`, `&>>`,
  `<<<`, here-documents (`<<`, `<<-`), process substitution (`<( )`,
  `>( )`)
- Words and quoting: single, double (with embedded expansions), `$'…'`
  ANSI-C quoting, backslash escapes
- Expansions: parameter (`${name:-word}`, `${#name}`, `${name//pat/repl}`,
  `${name:offset:length}`, case modifiers), command substitution
  (`$( )` and backticks), arithmetic (`$(( ))`, `$[ ]`), brace, tilde
- Full arithmetic precedence chain (assignment, ternary, logical,
  bitwise, shifts, equality, relational, additive, multiplicative,
  exponent, unary, primary)
- Declarations: `declare`, `local`, `export`, `readonly`, `typeset`,
  `unset` with options; array assignments; `trap`
- Comments
