# CSharp14 grammar

General C# grammar (EBNF) for the Minotaur parser platform, built on the
CSharp10 token layer (issue #194) and a new production layer written for the
DevelApp.StepParser GLR engine (`LexingMode.GreedyLongestMatch`). Per the
repository naming standard (issue #246), `CSharp14` is the general-versioned
grammar: it covers Declaration-C# widely, not only the jsb corpus dialect.

## Validation scope

Full-parse bar (grammar-harness: completed depth-1 parse path consuming the
whole token stream with contiguous coverage):

- The entire JsonSchemaBuilder (jsb) C# corpus: **66/66 files** across
  `CSharp/`, `CSharp/Funny/Onion/`, `CSharpEntities/`, `CSharpSystemTextJson/`
  (Newtonsoft and System.Text.Json attribute forms, deep nesting, nested
  classes, enums, delegates, initializers).
- A general-C# probe battery (10 probes): methods with bodies, constructors,
  if/else, enums (with backing type), interfaces, structs, delegates, events,
  keyword/qualified/generic/array/nullable property types, `const` fields,
  static readonly array initializers, expression-bodied members,
  `private set`, global usings, file-scoped namespaces, generic types with
  constraints, nested enums, doc comments (`///`), attributes on members.
- `Conformance.txt` lex pins (GrammarRepository conformance harness) and
  `Examples.txt` (whole-file lex + full-parse example).

## Included (parse level)

- `using` (incl. `global using`), block and file-scoped namespaces
  (`namespace N;` and `namespace N { ... }`), nested namespaces and types
- `class` / `interface` / `struct` / `record` declarations, nested types
  (2+ levels), `public partial`, attributes on members and type declarations
- Properties: `{ get; set; }` accessors, `private set`, `init`, single
  accessors, expression bodies (`=> expr;`), and property initializers
- Fields and constants with initializers (`= new List<string>();`,
  `= new X("...");`, `= new string[] { "a", "b" };` single-level braces)
- Methods with simple bodies; constructors; jump statements (`return`,
  `break`, `continue`, `yield`, `throw`, `await`); `var` and typed local
  declarations; `if`/`else`, `try`/`catch`/`finally`, loop heads with blocks
- Enums (comma-separated members, backing types, nested enums), delegates,
  events, operator-declaration heads
- Keyword types (`string`, `int`, `List<string>`, `List<List<T>>`,
  `X.Y.Z`, `X[]`, `DateTime?`, `T[]` arrays), `///` XML doc comments,
  `//` and `/* */` comments, preprocessor-shaped lines (`#`, skipped)

## Excluded (documented, v1)

- Assignment or invocation statements as statements (`x = 1;`, `Console.WriteLine(x);`
  inside bodies); wrapped/simple expressions beyond `var`/local/jump forms
- Indexers (`this[...]`), switch expressions, pattern matching, `unsafe`,
  pointers, attributes on parameters/return types, property hooks
- Query expressions (LINQ), stackalloc, verbatim/raw multi-line string
  formatting beyond the token layer's lexing coverage
- Expression operators (`+`, `?.`, etc.) outside `var`/initializer tokens:
  the engine's name-only GLR stack makes statement-level expression ladders
  a non-goal for v1; covered as token shapes when inside declared initializers

## Engine-discipline notes

The production layer follows GLR budget discipline learned from the jsb
corpus dialects (php85/sql2023) and engine issues #80/#83: contextual shifts
are anchored by explicit productions; `seq ::= seq seq | item` merge forms
garbage-collect tie-forked stacks; and every `{`/`}`/`;` literal is owned by
a specific production so the surviving-10 path budget always contains a
completable parse. `Grammar: CSharp14`, EBNF format, MIT license.

Lexer note: in `LexingMode.GreedyLongestMatch`, keyword tokens and the
`<identifier>` regex tie at equal length for reserved words, and the tie is
resolved by the lexer rule sort. In this grammar build `try`/`finally` win
that tie and bare `catch` loses (it lexes as `identifier`; a filtered
`catch (Exception ex)` already lexes as one `<flow_head>` token via longest
match). The production layer therefore anchors `catch_part` on
`<identifier>` and `<flow_head>` rather than on a `catch` keyword token.
Do not "fix" this with token priority annotations without revalidating the
whole corpus: giving any token rule a nonzero priority re-rolls the
priority-0 tie order for the entire token layer.
