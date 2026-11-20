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
- A general-C# probe battery: **10/10 probes** — methods with bodies,
  constructors, if/else, enums (with backing type), interfaces, structs,
  delegates, events, keyword/qualified/generic/array/nullable property
  types, `const` fields, static readonly array initializers,
  expression-bodied members, `private set`, global usings, file-scoped
  namespaces, generic types with constraints, nested enums, doc comments
  (`///`), attributes on members.
- The LaunchMobile-Builder application corpus: **30/32 C# files** (services,
  content composers/translators, resolver and packaging classes, test
  suites) — the two residual files fail on the documented engine-shape
  limits below, not on token coverage.
- `Conformance.txt` lex pins (GrammarRepository conformance harness) and
  `Examples.txt` (whole-file lex + full-parse example).

## Included (parse level)

Declarations:

- `using` (incl. `global using`), block and file-scoped namespaces
  (`namespace N;` and `namespace N { ... }`), nested namespaces and types
- `class` / `interface` / `struct` / `record` declarations, nested types
  (2+ levels), `public partial`, attributes on members and type declarations
- Properties: `{ get; set; }` accessors, `private set`, `init`, single
  accessors, expression bodies (`=> expr;`), and property initializers
- Fields and constants with initializers (`= new List<string>();`,
  `= new X("...");`, `= new string[] { "a", "b" };` single-level braces)
- Constructors with initializer chains (`: base(...)`, `: this(...)`)
  and nested statement bodies
- Methods with bodies; jump statements (`return`, `break`, `continue`,
  `yield`, `throw`, `await`); `var` and typed local declarations;
  `if`/`else`, `try`/`catch`/`finally`, `foreach`/`while` heads with blocks
- Enums (comma-separated members, backing types, nested enums), delegates,
  events, operator-declaration heads
- Keyword types (`string`, `int`, `List<string>`, `List<List<T>>`,
  `X.Y.Z`, `X[]`, `DateTime?`, `T[]` arrays), `///` XML doc comments,
  `//` and `/* */` comments, preprocessor-shaped lines (`#`, skipped)

Statement layer (application-scale C#):

- Assignment and invocation statements (`x = expr;`, `list.Add(item);`)
- Operator chains in statements and initializers
  (`+ - * / % && || ?? ! == != < > <= >=`)
- Ternary conditionals and `??` coalescing in statements
  (`v = a is { Length: > 0 } b ? b : fallback;`)
- Coalescing-throw declarations
  (`x = Deserialize<T>(json) ?? throw new Exception(...);`)
- `is { Prop: op value } var` property patterns (single-line)
- Awaited statements and awaited task blocks
- `foreach` with tuple destructuring (`foreach (var (a, b) in pairs)`)
- Multi-line `if` conditions with `&&`/`||`/`!` operator chains
- Expression-bodied members (whole `=> expr;` as one arrow token, incl.
  lambdas and `Any(x => ...)` inside argument positions)

## Excluded (documented)

- Nested collection-initializer pair entries (`{ { "a", "b" }, ... }`
  TheoryData rows): the rhs0 open-brace mass-fork poisons the surviving-path
  budget (residual `PluginUITests.cs` fail)
- Deep close-brace cascades at class end after the path budget has collapsed
  to tie-evicted junk stacks (residual `ScaffoldUITests.cs` fail; a budget /
  intra-step truncation race in the engine, not a missing production)
- Indexers (`this[...]`), switch expressions and statement bodies, pattern
  matching beyond the single-line `is { ... }` token, `unsafe`, pointers,
  attributes on parameters/return types, property hooks
- Query expressions (LINQ), stackalloc, verbatim/raw multi-line string
  formatting beyond the token layer's lexing coverage

## Engine-discipline notes

The production layer follows GLR budget discipline learned from the jsb
corpus dialects (php85/sql2023) and engine issues #80/#83: contextual shifts
are anchored by explicit productions; `seq ::= seq seq | item` merge forms
garbage-collect tie-forked stacks; and every `{`/`}`/`;` literal is owned by
a specific production so the surviving-path budget always contains a
completable parse. `Grammar: CSharp14`, EBNF format, MIT license.

Additional production-layer rules learned from the LaunchMobile-Builder
validation (all verified by full-battery regression):

- Never use mid-rhs `<a|b|c>` alternations of nonterminals: they fragment
  into partial-rhs garbage rules plus a unary wrapper that forks every
  identifier match. Write separate full lines per alternative.
- Never add unary wrapper rules over common nonterminals, and never reference
  an unreferenced root nonterminal (`compilation_unit`) from a new rhs:
  both un-root mid-parse rules and evict good paths globally.
- Root rules (lhs names never referenced on any rhs) only reduce at
  end-of-input, which makes brand-new `<absorb_*>` rules safe file-level
  EOF healers with zero mid-parse risk.
- Adding any token rule re-rolls contextual keyword classification for the
  whole token layer (e.g. `await` identifier-to-token, `base` token-to-
  identifier), so keyword-slot productions carry identifier variants and
  every grammar edit re-runs the full battery (66 corpus + 10 probes + 32
  application files).
- `&&`/`||` also lex/reduce as `op_symbol`; every operator-chain rule needs
  both the dedicated op alternative and the `op_symbol` variant.
- Multi-line if-conditions lex as a flow_head + flow_cmp/op pile; the `{`
  anchor needs rhs-prefix productions enumerating the exact pre-reduction
  pile (flow_tail-headed prefix matrix), not just a flow_head rule.

Lexer note: in `LexingMode.GreedyLongestMatch`, keyword tokens and the
`<identifier>` regex tie at equal length for reserved words, and the tie is
resolved by the lexer rule sort. In this grammar build `try`/`finally` win
that tie and bare `catch` loses (it lexes as `identifier`; a filtered
`catch (Exception ex)` already lexes as one `<flow_head>` token via longest
match). The production layer therefore anchors `catch_part` on
`<identifier>` and `<flow_head>` rather than on a `catch` keyword token.
Do not "fix" this with token priority annotations without revalidating
the whole corpus: giving any token rule a nonzero priority re-rolls the
priority-0 tie order for the entire token layer.
