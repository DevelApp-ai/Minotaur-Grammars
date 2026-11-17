# Language Version Support Matrix

Companion to [grammar-coverage-audit.md](grammar-coverage-audit.md) ·
Tracking: [SpecTreeGenerator#18](https://github.com/DevelApp-ai/SpecTreeGenerator/issues/18)

Every programming-language grammar must state the language version it supports.
Versions below are **verified from feature evidence** in the grammar productions
(not just header claims): a grammar "supports version X" when it contains the
productions for X's defining features.

## Policy

1. **Versioned identity**: a grammar's folder, `Grammar:` header, and metadata
   must name the supported version (e.g. `Java17`, `Python311`, `CSharp10`).
   "Java" alone is ambiguous and forbidden for new grammars.
2. **One grammar per version family, not per version**: grammars are supersets —
   `CSharp10` parses C# 1.0–10 code because it contains all older constructs.
   Declare support as a **range** (`baseline..X`) where verified. Split into a
   separate grammar only when syntax is mutually incompatible (e.g. Python 2
   vs 3).
3. **Range = verified only**: the range floor is the oldest version whose
   constructs all parse (no unknown-production errors); the ceiling is the
   newest version whose defining features are present.
4. **Evidence over claims**: the matrix below cites the feature that pins each
   version. Update this file whenever a grammar gains features.

## Verified version matrix

| Language | Grammar | Supported version(s) | Evidence |
|---|---|---|---|
| C | `C17` | C17 (ISO/IEC 9899:2018) | named; `_Static_assert`, `_Alignas` |
| C++ | `Cpp20` | C++17–C++20 | concepts, modules, coroutines, `<=>` |
| C# | `CSharp10` | C# 1.0–10 | records, `init`, file-scoped namespaces |
| Clojure | `Clojure` | Clojure 1.2+ | `defrecord`/`deftype` (1.2), atoms (1.0) |
| COBOL | `COBOL2023` | COBOL 2023 | named |
| Dart | `Dart` | Dart 3.0+ | records, patterns, sealed (all 3.0) |
| Elixir | `Elixir` | Elixir 1.x (subset) | core syntax, sigils, multi-clause `fn` |
| Erlang | `Erlang` | Erlang/OTP 17+ | maps (`#{}`), bit syntax |
| F# | `FSharp` | F# core (version not pinned) | records, unions, object expressions — needs pinning (follow-up) |
| Go | `Go119` | Go 1.18–1.19 | generics (1.18), named for 1.19 |
| Haskell | `Haskell` | GHC 7.6+ | `MultiWayIf`, `LambdaCase` |
| **Java (legacy)** | `Java` | **Java ≤ 7 — legacy, superseded** | **no lambdas / method refs (pre-8)**; use `Java17` |
| Java | `Java17` | Java 8–17 | named; records, sealed, `var` |
| JavaScript (legacy) | `JavaScript` | ES2015+ (embedded-HTML profile) | classes, arrows, template strings (ES6) |
| JavaScript | `JavaScriptES2022` | ES2022 | named; full ES2022 spec coverage |
| Kotlin | `Kotlin` | Kotlin 1.9+ (subset) | `data object` (1.9) |
| Lua | `Lua` | Lua 5.2–5.4 | `goto`/labels (5.2), attributes (5.4) |
| Perl | `Perl` | Perl 5.36+ (subset) | subroutine signatures |
| PHP | `PHP` | PHP 8.2 (subset) | `readonly` class (8.2), enums (8.1), `match` (8.0) |
| Python | `Python311` | Python 3.11 | named; match, `except*`, `type` statement |
| R | `RLang` | R 4.1+ | native pipe `\|>` (4.1), raw strings (4.0) |
| Ruby | `Ruby` | Ruby 2.3+ (subset) | safe navigation `&.` (2.3), `refine` (2.0) |
| Rust | `Rust2021` | Rust 2021 edition | named |
| Scala | `Scala` | Scala 3 (subset) | `export`, `given`, `opaque`, `end` (all 3.0) |
| Swift | `Swift` | Swift 5.5 (subset) | actors, async/await (5.5), wrappers (5.1) |
| TypeScript | `TypeScript` | TS 4.1–5.0 features on ES2022 base | template literal types (4.1), `infer` (4.7), decorators (5.0); no `satisfies` (4.9) |
| VB.NET | `VisualBasic` | VB.NET 8+ (VS 2005) | `Using` statement (VB8) |
| WebAssembly | `WebAssembly20` | WASM 2.0 (text format) | named |

Non-versioned formats (XML, JSON, JSON Schema, XAML, PL/I, CSS, HTML, project
grammars) are out of scope for this matrix; CSS should eventually pin a level
(follow-up).

## Defects found during verification

1. **`java/Java.grammar` is pre-Java 8** (no lambdas, no method references) yet
   named just "Java" — actively misleading. Renamed identity is blocked by the
   `ProjectLoader` legacy-name mapping; instead it is marked **legacy** here and
   consumers must use `Java17`. Candidate for deletion once nothing references it.
2. **Four grammars share the wrong `Grammar:` header value `CEBNF`**: `CSS`,
   `JavaScript` (legacy), `JavaScriptES2022`, `Rust2021`, `WebAssembly20`. The
   header should identify the grammar, not the format type. Renaming needs
   consumer coordination (ProjectLoader + grammar-index.json) — tracked as follow-up.
3. **`FSharp` does not pin a version** — core constructs only; needs a feature
   sweep to pin (e.g. `task {}` would pin F# 6).
4. **`CSS` does not pin a level**.

## Multi-version grammar guidance

To support several versions in one grammar (preferred):

- Include the union of productions across the target versions; use optional
  constructs (`?`) for version-gated syntax so older code still parses.
- Where syntax changed incompatibly across versions (e.g. Python 2 `print`
  statement vs 3 `print()`), prefer separate grammars over a broken union.
- Record the supported range in the grammar header comment, metadata
  `Description`, and this matrix.
