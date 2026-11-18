# VisualBasicJsb grammar

Disciplined grammar for the Visual Basic dialect emitted by JsonSchemaBuilder
(jsb), authored for the DevelApp.StepParser engine (1.75.0, GreedyLongestMatch)
as the VB row of Minotaur-Grammars issue #220. `VisualBasicJsb.grammar` is the
main file; `Labyrinth.extension` is an optional overlay.

## Scope (inclusion)

Exactly the shapes the jsb corpus (`JsonSchemaBuilder.Test/VB/{Default,Funny/Onion}`,
21 files) emits:

- Fixed five-line `Imports` block, absorbed as ONE greedy `imports_block` token
  (issue #223 finding 7, like php85's `<?php` and CSharp14's using block).
- `Namespace [Default]` (bracketed name) or dotted names like `Funny.Onion`.
- `'''` doc comments (lexed as line comments, skipped).
- `Partial Public Class <name> ... End Class`, nested up to corpus depth (2 per
  file; stress-verified to 3 levels).
- Class members: `<JsonProperty("x")> Public Property <name> As <type>`,
  optionally with `= <initializer>`; the single-annotation-plus-converter form
  `<JsonProperty("x"), JsonConverter(GetType(StringEnumConverter))>`.
- Types: `String`, `Boolean`, `Long`, `Long?`, `Date`, `Date?`, `Object`,
  bare identifiers (enum references), `List(Of T)` and `List(Of List(Of T))`.
  The whole `As <type>` span is ONE greedy `as_type` token.
- Initializers: `= New List(Of T)()`, `= New Identifier("lit")`,
  `= DateTime.Parse("lit")` (qualified); the whole `= <expr>` span is ONE
  greedy `init_expr` token.
- `Public Enum <name>` with 0-4 bare identifier values, `End Enum`, at most
  one per class (values enumerated per count, JSONSchemaDraft7 shape).

## Scope (exclusion)

Deliberately NOT accepted (negative probes fail by design): `Sub`/`Function`
members, `Dim`/fields without annotation, `Friend`/`Private`/`Structure`
declarations, enums with explicit values (`Alpha = 1`), non-partial classes,
missing `As` clauses, numeric literals, and generally anything outside the
jsb emission shape.

## Engine-discipline notes (why the grammar looks like this)

Findings from this row (DevelApp.StepParser 1.75.0), beyond the earlier
CSharp14/JSONSchemaDraft7/TypeScriptJsb/JavaJsb findings:

1. **Reduction-score inflation evicts correct parses.** The GLR scorer
   multiplies a path's score by 1.1 per reduction and 0.95 per shift
   (StepParser.GLR.cs). Rules like `vb_type ::= ... | <identifier>` that can
   reduce a bare identifier fire on EVERY identifier (class names, enum
   names, enum values), forking score-inflated junk twins that crowd the one
   correct path out of the 10-path budget on fork-heavy files. First observed
   here as: every enum-bearing corpus file died at the `End Class` after
   `End Enum` because the class name had been reduced to `vb_type`. Fix:
   no rule in this grammar reduces a bare identifier - the type is absorbed
   into the `as_type` greedy token and the initializer into `init_expr`.
2. **Escaped-adjacency lexing gap.** A token-rule regex containing `\(`
   immediately followed by `\)` is rejected by the lexer's supported-pattern
   validation (issue #129 subset check). Use `\x28`/`\x29` hex escapes for
   literal parentheses (the same reason C17 writes `/` as `\x2F`).
3. **Enumerated same-kind nested sequences fork worse than merges.** Unlike
   JSONSchemaDraft7 (flat member lists), VB class bodies nest
   `class_item_seq` inside `class_item` inside `class_item_seq`. Enumerating
   the sequence 1..12 made every corpus file with nested classes fail;
   the separator-free merge `seq ::= seq item | item` keeps the family small.
   The binary `seq ::= seq seq` merge is unnecessary and was dropped.
4. **Known engine limitation (documented, not fixed):** a synthetic file
   combining a 3-value enum + a nested class + a converter annotation + an
   initializer member in ONE class can exceed the 10-active-path budget:
   reduction-inflated skip-prefix paths (resting depth-1 paths that skip the
   prologue, then shift mid-file) crowd out the correct parse. All 21 corpus
   files and all realistic stress probes stay well under the budget; the
  limitation only bites when every fork-heavy construct is stacked in one
  class.
5. **Resting looseness (accepted, as in previous rows):** the engine's
   resting depth-1 paths mean a file without the `Imports` prologue still
   parses (a depth-1 `namespace_decl` path wins). The prologue therefore
   cannot be a negative-test; it is documented here instead.

## Validation (DevelApp.StepParser 1.75.0, GreedyLongestMatch)

- jsb corpus: **21/21 PASS** with the honest harness (winning path consumed
  the full token stream contiguously).
- Stress probes PASS beyond corpus maxima: 12 members with all type and
  initializer shapes, 3-level class nesting, 4-value enum.
- 10 negative probes: 9 FAIL by design; the missing-prologue probe parses due
  to the resting looseness above.
- Conformance: 19 `lex:` pins, 5 `fail:` pins and `lexfile: Examples.txt`
  verified with a lex-only checker mirroring GrammarRepositoryConformanceTests;
  `Examples.txt` also full-parses.
