# JavaJsb

Minotaur grammar for the Java dialect emitted by the
JsonSchemaBuilder (jsb) generator, hand-authored for the
ENFAStepLexer-StepParser engine and validated against the jsb Java
corpus (`JsonSchemaBuilder.Test/Java/{Default,Funny/Onion}`, 21
files), all passing with contiguous byte coverage under
`LexingMode.GreedyLongestMatch`.

## Why a new grammar

The existing general grammars `java17/Java17.grammar` and
`java8/Java8.grammar` pass 0/21 of the jsb corpus (issue #220: Java17
fails at position 1, its root rule uses CEBNF `?`/`+` lists that never
fold; Java8 reaches no completed depth-1 path under the 10-path GLR
budget). The jsb Java generator emits a narrow, fully regular
POJO-with-Jackson dialect, so this is a disciplined subset grammar
authored against the engine's real behavior; the general grammars are
untouched.

## Validation scope

The grammar is a **disciplined subset**, not Java. It accepts the
declaration shapes jsb emits and rejects everything else. It is the
right tool for validating jsb output; it is NOT a general-purpose
Java grammar.

### Included

- `package <name>;` (simple or dotted name)
- The import block: one or more `import <qualified>;` lines, absorbed
  as ONE token (the jsb prologue is 10 fixed imports; probes with 1-3
  imports pass). Import contents are not restricted to the jsb set.
- Exactly one `public class <Name> { ... }` per file, with doc
  comments as skip tokens (single or doubled, both occur in the corpus)
- Class items in any order and count: members, `public static class`
  nested classes (corpus depth 2, probes to depth 3 pass), `public
  enum` string-value enums
- Members: `@JsonProperty("...")` (one greedy token), `private
  <Type> <name>;` or `private <Type> <name> = <init>;`, then the getter
  `public <Type> get<Name>() { return <name>; }` and setter
  `public void set<Name>(<Type> <name>) { this.<name> = <name>; }`
- Types: `String`, `Boolean`, `Long`, `Object`, bare identifiers,
  `List<T>` and nested `List<List<T>>` (T: keyword types or
  identifiers, e.g. `List<LocalDate>`, `List<List<Foo>>`)
- Initializers: `new ArrayList<>()`, double-quoted string literals,
  `<Qualified>.parse("...")` (covers `LocalDate.parse` etc.)
- Enums (corpus: 1 per file, 3 values): `public enum <Name> {`
  values `Name("literal"),` x N-1 + `Name("literal");` (enumerated
  1-4 values), then the fixed jsb scaffold: `private final String
  value;`, the `<Name>(String value) { this.value = value; }`
  constructor, `@JsonValue public String getValue() { return value; }`

### Excluded

- Everything else in Java: interfaces, methods with logic, control
  flow, constructors on classes, static/instance initializer blocks,
  generics beyond `List<T>`/`List<List<T>>`, arrays `T[]`, primitives
  (`int`, `boolean`, ...), annotations other than `@JsonProperty(...)`
  and `@JsonValue`, modifiers other than the emitted ones
- `//` line comments (jsb emits none; a stray `//` fails lexing by
  design)
- Numeric literals, char literals, single-quoted strings, `this(...)`
  constructor calls (all fail lexing or parsing by design)
- Enums with more than 4 values; enum values without string literals;
  trailing commas after the last enum value

### Known, accepted loosenesses (structural grammar, documented)

- Getter/setter/field NAME AGREEMENT is not enforced (`getX` may
  return `y`): the engine has no cross-token equality constraint.
- Setter bodies accept any `<identifier>.<identifier> = ...` shape the
  qualified_name token can match, not literally `this.<field>`.
- The engine starts depth-1 paths from any rule at token 0, so a bare
  class (without the package/import prologue) also parses; the
  prologue cannot be made mandatory at depth 1 (same engine behavior
  as CSharp14's optional using block).
- The import block accepts any qualified imports, not just the 10
  jsb ones.

### jsb corpus maxima (verified)

Members per class: 9 (probes to 10 with all type shapes). Nested
classes per file: 2 (probes to 2 levels of nesting beyond corpus, i.e.
depth 3). Enums per file: 1, with 3 values (probes to 4). Imports: the
fixed 10-line block (probes with 1-3 imports pass).

## Engine-discipline notes (why the grammar looks like this)

The grammar is written against known engine behaviors of
DevelApp.StepParser 1.75.0. These are working disciplines, and also
upstream engine findings worth fixing in ENFAStepLexer-StepParser:

1. **No CEBNF repetition**: `*`/`+`/`?` never fold (issue #217 finding
   4), so class item lists use the separator-free `seq ::= seq item |
   item | seq seq` merge (php85/CSharp14 shape, empirically safe
   without separators - TypeScriptJsb session finding) and enum value
   lists are enumerated (they have a ',' separator; left-recursive
   separator lists fork immortal fold twins, JSONSchemaDraft7 finding).
2. **Single-token absorption for repeated prologues** (issue #223
   finding 7): the import block is ONE greedy regex token, like
   php85's `<?php` and CSharp14's using_block. Per-import rules would
   fork at every import and evict deep paths.
3. **Greedy token absorption kills fork points**: `@JsonProperty("x")`
   is ONE token (annotation name + string literal), and
   `this.<field>` / `LocalDate.parse` lex as single qualified_name
   tokens (issue #223 finding 8: the RHS takes the token directly).
   This keeps members to ~25 tokens and item boundaries to 2-3
   short-lived forks, far under the 10-path GLR budget (deepest
   corpus file: FtpInformation, enum + 9 members).
4. **No standalone rule starts with a punctuation literal**: `'='` in
   initializers and setter bodies sits mid-RHS. A literal at rhs
   position 0 of an auxiliary rule shifts onto any path and creates
   zombie forks (issue #223 finding 6).
5. **No singleton-token rules**: `item ::= token` mis-fires through
   the no-lookahead reduction check on every value position
   (JSONSchemaDraft7 session finding); every production has a
   structured RHS.
6. **Resting depth-1 paths** survive arbitrary unconsumed tokens, so
   validation verifies contiguous consumption of the winning path
   (the jsb corpus harness does), not just "a completed path exists".

Implements the Java half of issue #220 (jsb corpus coverage).
