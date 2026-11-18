# PHP85

Minotaur grammar for PHP 8.5, hand-authored for the ENFAStepLexer-StepParser
engine and validated against machine-generated PHP: the JsonSchemaBuilder
(jsb) PHP generator corpus (22 files: `Default/` + `Funny/Onion/`,
regenerated 2026-11 after jsb PRs #36/#37-#40 merged), all passing with contiguous byte coverage under `LexingMode.GreedyLongestMatch`.

## Why a new grammar

Replaces the removed `programming-languages/php/` toy grammar (issue #58,
closed without a replacement grammar). PHP and SQL grammars are now
versioned like the rest of the repository.

## Validation scope

The grammar is a **disciplined subset**, not full PHP 8.5. It accepts the
language shapes jsb emits (declaration file prologue, classes, interfaces,
traits, enums, typed properties, enum cases, methods with parameters) and
rejects everything else. It is the right tool for validating jsb PHP output;
it is NOT a general-purpose PHP grammar.

### Included

- `<?php` open tag, `declare(strict_types=1);`, `namespace Name;`
- `class`/`interface`/`trait`/`enum` declarations (0-3 modifiers each,
  `extends`/`implements`, enum backing-type `: string|int`)
- Typed properties: 1-3 member modifiers, nullable `?type`, qualified and
  simple types, per-class member sequences of any length
- Enum cases (`case X;`, `case X = expr;`), constants-shaped cases included
- Methods/functions with typed, defaulted parameters (inlined
  `parameter_list` forms), arrow functions, closures
- `if`/`elseif`/`else`, `while`, `do`, `for`, `foreach`, `try`/`catch`/`finally`
- `echo` (1-2 expressions), `return`, `break`, `continue`, `throw`, `goto`,
  `unset`, `match`, `new`, `instanceof`
- Flat binary/assignment expression ladder (no precedence; the corpus needs
  none), postfix `->`/`::`/`[]`/call chains
- `use` declarations (single-qualified-name form), attributes
- `//` and `/* */` comments, `'...'` and `"..."` string literals,
  int/float literals, variables, qualified names with leading `\`

### Excluded (documented, by design)

- Heredoc/nowdoc syntax; `#`-comments
- `?>` close tag (declaration files only)
- Bare expression statements (`$x = 1;`, `$x;` at statement level)
- Top-level `global`/`static` variable statements
- `switch` statements; `const` declarations (top-level and class-level)
- `use` group forms (`use A\{B, C};`), `use` with commas
- Method return-type annotations; property hooks beyond the enumerated forms
- `list()`/array literal forms beyond the parenthesized subset
- Unary operators, unary `+`/`-`/`!`/`~`, casts
- `echo` beyond 2 expressions; `print`
- Variadic/by-ref method parameters beyond `...`/`&` token support
- for-loop multi-expression clauses
- Method bodies with statement sequences: keyword-anchored but NOT
  exercised by the corpus; deep bodies may exhaust the engine's 10-path
  budget (see below)

## Engine-discipline notes (why the grammar looks like this)

The grammar is written against known engine behaviors of
DevelApp.StepParser 1.75.0. These are working disciplines, and also
upstream engine findings worth fixing in ENFAStepLexer-StepParser:

1. **Left-recursive lists** (`seq ::= seq item | item`) fold correctly;
   CEBNF `*`/`+` generate right-recursive helpers that never fold
   left-to-right lists, so counts are enumerated instead.
2. **Root sequence**: `<script> ::= <open_tag> <top_statement_seq>`
   with the separator-free binary merge `seq ::= seq seq | seq_item`
   (corpus max 8 top statements: `declare` + `namespace` + 5 top-level
   classes in `JsonPointerRef.php`). An enumerated `open_tag + 0..N
   top_statement` root died at 7+ statements, and a LINEAR merge
   `seq ::= seq item` also evicts the correct path at 8 statements;
   the binary merge folds correctly within the 10-path budget.
3. **Path budget (10)**: the parser keeps 10 GLR paths, pruned by
   (TokenPosition, Score). Ambiguous rule families spawn junk
   interpretations that can evict the correct path on long inputs. Rules
   are therefore keyword-anchored, unguarded list bases are avoided, and
   `statement` was narrowed to declarations so junk wraps cannot stack.
4. **Fork-direction tolerance**: eager folds (e.g. `identifier` to
   `type_ref`, `=` to `assignment_op`) mean a rule must exist for every
   fold shape that can survive on the stack (both `expr`-named and
   `type_ref`-named declaration forms exist for this reason).
5. **Loader quirks**: single-quoted-literal production rules with exactly
   one alternative are classified as *token* rules, so multi-alternative
   type rules are written on one line. Comment lines between rules are
   absorbed into the preceding rule by the multi-line collector, so this
   grammar file contains no comment lines.
6. **Score float precision**: scores compound to ~1e-4 on long files, so
   prune ties are effectively broken by sort order.

## AST validation goals

- jsb-generated declaration files parse completely, with contiguous
  byte coverage (no silently skipped input)
- Structural changes in the generator output surface as parse errors

Implements the PHP half of issues #58 / #77 (versioned PHP/SQL grammars).
