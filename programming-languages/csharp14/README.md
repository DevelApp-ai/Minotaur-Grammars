# CSharp14

Minotaur grammar for C# 14, hand-authored for the ENFAStepLexer-StepParser
engine and validated against machine-generated C#: the JsonSchemaBuilder
(jsb) C# generator corpus (63 files: `CSharp/`, `CSharpEntities/` and
`CSharpSystemTextJson/` variants, `Default/` + `Funny/Onion/` each), all
passing with contiguous byte coverage under `LexingMode.GreedyLongestMatch`.

## Why a new grammar

The existing `CSharp10.grammar` fails the entire jsb C# corpus (0/63:
parse errors around the third `using` directive and GLR budget exhaustion
on multi-member class bodies; see issue #220). This grammar accepts the
language shapes jsb actually emits and rejects everything else. It is the
right tool for validating jsb C# output; it is NOT a general-purpose
C# grammar.

## Validation scope

The grammar is a **disciplined subset**, not full C# 14.

### Included

- `using` directive blocks (any count, each `using <qualified-or-simple-name>;`)
- `namespace <name> { ... }` block form, simple and qualified names
- `///` XML doc comments and `//` line comments, whitespace
- `public partial class X` declarations, nested to any depth,
  empty bodies allowed
- `public enum X { A, B, C }` (identifier members, no trailing comma,
  no explicit values, no attributes)
- Properties: `public <type> <Name> { get; set; }`, with optional
  `[JsonProperty("...")]` / `[JsonPropertyName("...")]` attribute,
  optional nullable `?` types, and optional initializers
  `= new List<T>();`, `= new X();`, `= new X("...");`,
  `= DateTime.Parse("...");` (and any `<qualified>.<name>("...")` call form)
- Attributes with one or two comma-separated items, including
  `[JsonProperty("..."), JsonConverter(typeof(X))]`
- Types: `string`, `bool`, `object`, `long` (optional `?`), identifiers,
  `List<T>` including `List<List<T>>`, `List<long>`, `List<X>`

### Excluded (documented, by design)

- Methods, constructors, fields, events, indexers, operators
- Non-public or non-partial classes; `abstract`/`sealed`/`static` modifiers
- File-scoped namespaces (`namespace X;`); `global using`; `using static`;
  alias directives
- Expression-bodied properties; init-only setters; property hooks
- Enums with explicit values, flags attributes, trailing commas
- Records, structs, interfaces, delegates, generics beyond `List<T>`
- Multi-line `/* */` comments, verbatim/interpolated strings, char literals,
  numeric literals
- Records with positional parameters, pattern matching, statements of any
  kind (no method bodies)
- `var`, arrays, tuples, LINQ, async, exceptions

## Engine-discipline notes (why the grammar looks like this)

- **The whole `using` block is one token.** `using A.B.C;` directives are
  lexed as a single greedy `using_block` token. Enumerated per-directive
  root alternatives (0..N usings) explode the engine's 10-path GLR budget:
  every `using` starts a rhs, so unreduced directive fragments shift onto
  junk paths that crowd out the correct parse on files with 3+ usings.
  One token = one shift = no forks in the prologue. (Same medicine as
  php85's `<?php` open-tag token.)
- **No rhs starts with `=`.** Property initializers are inlined into the
  property rule (`... '}' '=' <init_expr> ';'`). When `=` could start a
  rule, it is shiftable on any path, and after a no-initializer property
  reduces, `= new List<X>()` survives as a 7-token zombie path that forks
  at every token and evicts the correct deep path.
- **No comment lines in the grammar file**: the loader glues any non-rule
  line after a production rule into that rule's rhs.
- **`\x2F` (not `\/`)** for `/` inside skip/token regexes; `\/` silently
  invalidates the rule.
- **Enumerated property forms** (attribute x initializer), no CEBNF
  optionals (`?`/`*`/`+` never fold left-to-right in this engine).
- **Left-recursive member sequences with a `seq ::= seq seq` merge rule**
  for class and namespace bodies.
- **`DateTime.Parse` arrives as one `qualified_name` token** under
  GreedyLongestMatch, so the initializer call form takes the token
  directly rather than `identifier '.' identifier`.

## Files

- `CSharp14.grammar` - the grammar (comment-free by engine necessity)
- `Conformance.txt` - engine-verified lexing pins (lex:/fail:/lexfile:)
- `Examples.txt` - example corpus (parses PASS; also the lexfile pin)
- `Labyrinth.extension` - optional Labyrinth target overlay (#184)
- `minotaur-metadata.json`, `LICENSE`, this README

## Validation

- jsb corpus: 63/63 files PASS (three C# output variants, 21 files each).
- Negative controls: methods, private fields, malformed usings and
  expression-bodied properties are rejected (FAIL by design).
- `Examples.txt` parses PASS under this grammar.
