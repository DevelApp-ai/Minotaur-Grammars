# TypeScriptJsb

Minotaur grammar for the TypeScript dialect emitted by the
JsonSchemaBuilder (jsb) generator, hand-authored for the
ENFAStepLexer-StepParser engine and validated against the jsb TypeScript
corpus (`JsonSchemaBuilder.Test/TypeScript/{Default,Funny/Onion}`, 22
files, regenerated 2026-11 after jsb PRs #36/#37-#40 merged; the
TypeScriptJsb grammar parses it unchanged), all passing with contiguous byte coverage under
`LexingMode.GreedyLongestMatch`.

## Why a new grammar

The existing `programming-languages/typescript/TypeScript.grammar` is a
general ES2022 + type-system grammar; it passes 0/21 of the jsb corpus
files (issue #220: no completed depth-1 path, early parse errors, GLR
hangs). The jsb TypeScript generator emits a narrow, fully regular
declaration subset, so this grammar is a disciplined subset grammar
authored against the engine's real behavior; the existing general
grammar is untouched.

## Validation scope

The grammar is a **disciplined subset**, not TypeScript. It accepts the
declaration shapes jsb emits and rejects everything else. It is the
right tool for validating jsb output; it is NOT a general-purpose
TypeScript grammar.

### Included

- `import type { X } from './y';` type-only imports (single named import)
- `export interface Name { ... }` with 0-9 members (corpus maximum;
  verified to 12 members and 12 interfaces per file beyond the corpus)
- `export type Name = 'A' | 'B' | 'C';` string-literal union aliases
  (1-3 literals)
- Members: `name: T;` and `name?: T;`, each optionally preceded by a
  `/** ... */` doc comment (one skip token)
- Types: `string`, `number`, `boolean`, `object`, bare identifiers
  (cross-file/enum references), `T[]` arrays, `T[][]` arrays of arrays
- Block comments and whitespace as skip tokens; single-line
  declarations are accepted as well as corpus-style multi-line layout

### Excluded

- Everything else in TypeScript: classes, functions, expressions,
  statements, generics, `declare`, default exports, re-exports,
  multi-name imports, `readonly`/`extends`/`implements` clauses,
  index signatures, method signatures, numeric/enums-as-values,
  template literals, decorators
- `//` line comments (jsb emits none; a stray `//` fails lexing by
  design)
- Numeric and double-quoted literals (jsb emits none; digits and
  `"..."` fail lexing by design), `string[][]` and deeper/other-simple
  array bases (`identifier[][]` only, per corpus)
- Union type aliases whose members are not single-quoted string
  literals

### jsb corpus maxima (verified)

Interfaces per file: 3 (probes to 12). Members per interface: 9
(probes to 12). Imports per file: 1 (probes to 5, always first). String
literals per type alias: 3. Arrays of arrays: identifier base only.

## Engine-discipline notes (why the grammar looks like this)

The grammar is written against known engine behaviors of
DevelApp.StepParser 1.75.0. These are working disciplines, and also
upstream engine findings worth fixing in ENFAStepLexer-StepParser:

1. **No CEBNF repetition**: `*`/`+`/`?` never fold (issue #217 finding
   4), so every list is either a separator-free `seq ::= seq item |
   item | seq seq` merge (module items, interface members - the same
   shape php85 and CSharp14 use, empirically safe without separators)
   or enumerated alternatives (type-alias union literals).
2. **No-lookahead reductions create fold twins**: `CanApplyReduction`
   matches the stack top against each rule's reversed RHS with no
   lookahead; on left-recursive lists *with separators*
   (`seq ::= seq ',' item | item`) it forks immortal separator-layered
   twins that evict the correct path (JSONSchemaDraft7 session
   finding). The separator-free merge form does not trigger this:
   there is no pending separator for the base rule to fire above.
3. **Universal rhs-position-0 shiftability** (issue #223 finding): a
   literal at rhs position 0 of a standalone rule shifts onto any
   path. `'export'`, `'import'` and the member keywords sit at position
   0 of their rules; this is safe here because those are the only
   legal item starts after a completed item, and no auxiliary rule
   starts with a punctuation literal (no rule begins with `'{'`,
   `'['`, `'|'` or `';'`).
4. **Singleton-token rules mis-fire**: `item ::= token` fires through
   the no-lookahead reduction check on every value position and
   destroys the parse (empirically 0/16 when tried for
   JSONSchemaDraft7); every production has a structured RHS instead.
5. **Resting depth-1 paths**: any depth-1 path survives arbitrary
   unconsumed tokens, so validation must verify contiguous consumption
   of the winning path (the jsb corpus harness does), not just "a
   completed path exists".
6. **Path budget (10)**: the parser keeps 10 GLR paths pruned by
   (TokenPosition, Score). The two member alternatives and the
   keyword-vs-identifier type alternatives fork briefly at each
   member; the deepest corpus file (FtpInformation, 9 members + enum +
   doc comments) stays far below the budget, and 12-interface /
   12-member probes pass.

Implements the TypeScript half of issue #220 (jsb corpus coverage).
