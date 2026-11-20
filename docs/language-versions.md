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
   "Java" alone is ambiguous and forbidden for new grammars. The version in the
   name is the *language* version the grammar targets (e.g. `PHP` targets
   PHP 8.2 - see the matrix; do not invent a `001` language version). The
   `001` counter is reserved for the meta/project grammars that have no
   internal format version (`ExtensionFile001`, `FolderProject001`,
   `GrammarFile001`, `DotNetProject001`): their number is the grammar's own
   revision, so a future format change becomes `002`, `003`, ...
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
| C | `C17` | C17 (ISO/IEC 9899:2018) | named; `_Static_assert`, `_Alignas`; full lexing surface engine-verified (Conformance.txt + Examples.txt) |
| C++ | `Cpp20` | C++17–C++20 | concepts, modules, coroutines, `<=>`; full lexing surface engine-verified (raw/prefixed strings, digit separators, Conformance.txt + Examples.txt) |
| C# | `CSharp10` | C# 1.0–10 | records, `init`, file-scoped namespaces |
| Clojure | `Clojure` | Clojure 1.2+ | `defrecord`/`deftype` (1.2), atoms (1.0); full lexing surface engine-verified (symbols/keywords, ratios/radix, Conformance.txt + Examples.txt) |
| COBOL | `COBOL2023` | COBOL 2023 | named |
| Dart | `Dart` | Dart 3.0+ | records, patterns, sealed (all 3.0); full lexing surface engine-verified (raw/triple strings, cascades/spread, Conformance.txt + Examples.txt) |
| Elixir | `Elixir` | Elixir 1.x | core syntax, sigils, multi-clause `fn`; full lexing surface engine-verified (atoms, sigils, heredocs, Conformance.txt + Examples.txt) |
| Erlang | `Erlang` | Erlang/OTP 17+ | maps (`#{}`), bit syntax; full lexing surface engine-verified (atoms, $ chars, radix numbers, Conformance.txt + Examples.txt) |
| F# | `FSharp` | F# core (version not pinned) | records, unions, object expressions — needs pinning (follow-up) |
| Go | `Go119` | Go 1.18–1.19 | full surface engine-verified (Conformance.txt: generics + `~` constraints, type aliases, all literals incl. raw strings/imaginary, all statement forms); named for 1.19 |
| Haskell | `Haskell` | Haskell 2010 + MultiWayIf/LambdaCase (GHC 7.6+ evidence) | `MultiWayIf`, `LambdaCase`; full lexing surface engine-verified (symop class, hex/octal, `{- -}`/`--` comments, pragmas; Conformance.txt + Examples.txt) |
| **Java (legacy)** | `Java` | **Java ≤ 7 — legacy, superseded** | **no lambdas / method refs (pre-8)**; use `Java17` |
| Java | `Java17` | Java 8–17 | named; records, sealed, `var`; full lexing surface engine-verified (text blocks, suffixed literals, Conformance.txt + Examples.txt) |
| JavaScript (legacy) | `JavaScript` | ES2015+ (embedded-HTML profile) | classes, arrows, template strings (ES6) |
| JavaScript | `JavaScriptES2022` | ES2022 | named; full ES2022 spec coverage; full lexing surface engine-verified (templates, bigint, Conformance.txt + Examples.txt) |
| Kotlin | `Kotlin` | Kotlin 1.9+ | `data object` (1.9); full lexing surface engine-verified (raw strings, backtick idents, elvis, Conformance.txt + Examples.txt) |
| Lua | `Lua` | Lua 5.4 | `goto`/labels (5.2), integer div + bitwise (5.3), `<close>` attributes (5.4); full lexing surface engine-verified (long strings/comments, hex floats, `//`, varargs; Conformance.txt + Examples.txt) |
| Perl | `Perl` | Perl 5.36+ | subroutine signatures; full lexing surface engine-verified (q//m//s///, sigil vars, Conformance.txt + Examples.txt) |
| PHP | `PHP` | PHP 8.2 (subset) | `readonly` class (8.2), enums (8.1), `match` (8.0) |
| Python | `Python311` | Python 3.11 | named; match, `except*`, `type` statement; full lexing surface engine-verified (prefixed/triple strings, all number forms, Conformance.txt + Examples.txt) |
| R | `RLang` | R 4.1+ | native pipe `\|>` (4.1), raw strings (4.0); full lexing surface engine-verified (%op%, slots, hex floats, Conformance.txt + Examples.txt) |
| Ruby | `Ruby` | Ruby 2.3+ | safe navigation `&.` (2.3), `refine` (2.0); full lexing surface engine-verified (symbols, %sigils, ivars/gvars, Conformance.txt + Examples.txt) |
| Rust | `Rust2021` | Rust 2021 edition | named; full lexing surface engine-verified (raw strings, byte strings, lifetimes, suffixed numbers, Conformance.txt + Examples.txt) |
| Scala | `Scala` | Scala 3 | `export`, `given`, `opaque`, `end` (all 3.0); full lexing surface engine-verified (symbolic idents, interpolated strings, Conformance.txt + Examples.txt) |
| Swift | `Swift` | Swift 5.5 | actors, async/await (5.5), wrappers (5.1); full lexing surface engine-verified (raw strings, ..<, $0, Conformance.txt + Examples.txt) |
| TypeScript | `TypeScript` | TS 4.1–5.0 features on ES2022 base | template literal types (4.1), `infer` (4.7), decorators (5.0); no `satisfies` (4.9) |
| VB.NET | `VisualBasic` | VB.NET 8+ (VS 2005) | `Using` statement (VB8) |
| WebAssembly | `WebAssembly20` | WASM 2.0 (text format) | named |

## New grammars added in #299-#303 (2026-11, tracking #247)

All 51 grammars below are engine-verified full (v2.0.0 metadata, `Conformance.txt`
with `lex:`/`fail:`/`lexfile: Examples.txt` pins enforced in CI, real `Examples.txt`,
MIT `LICENSE`, `grammar-index.json` entry). Language grammars carry the version in the
folder name where the language has a stable version; platform-pinned languages
(ABAP, Apex, JCL, HLASM, AWK, sed) are named by the platform release they target and
listed here with that pin. Parse-level (not just lex-level) verification of these
grammars is pending engine #157.

| Language | Grammar | Supported version(s) | Evidence |
|---|---|---|---|
| ABAP | `abap` | ABAP 7.50 (SAP BTP) | `DATA ... TYPE`, `SELECT ... INTO`, `WRITE: /`, `LOOP AT`, field symbols `<fs>` |
| Ada | `ada2022` | Ada 2022 | named; `16#FF#` based literals, `'Image` attributes, `case ... when others =>` |
| Apex | `apex` | Salesforce Apex, API v60 | `@RestResource`, SOQL `[SELECT ... FROM ... WHERE ...]`, `global with sharing class` |
| AWK | `awk` | POSIX awk / gawk 5.x | `BEGIN`/`END`, `$1` field refs, `printf`, `function`, `NR`/`NF` |
| Common Lisp | `lisp` | ANSI X3.226-1994 | `defun`, quote/quasiquote `'` `` ` `` `,`, `, @`, `3/4` ratios, `#xFF` radix |
| Crystal | `crystal1` | Crystal 1.x | named; `def`, `case ... when`, string interpolation `#{}`, `||=` |
| CUDA | `cuda12` | CUDA 12 | named; `__global__`/`__device__`, `<<<grid, block>>>` launch, `blockIdx`/`threadIdx`, `R"(...)"` raw strings |
| D | `d2` | D 2.x | named; `/+ +/` nested comments, `r"..."` raw + backtick strings, `foreach (i; 0 .. 10)` |
| Fortran | `fortran2023` | Fortran 2023 (free-form) | named; `!` comments, `do while`, `character(len=*)`, kind-suffixed reals, `intent(inout)` |
| GDScript | `gdscript4` | GDScript 4 (Godot 4) | named; `@export`, `signal`, `func ... -> void`, `:=`, `$Node` paths, `match` |
| Gleam | `gleam1` | Gleam 1.x | named; `pub fn`, `|>`, `<>` concat, `case { [x, ..] -> }` spreads |
| GLSL | `glsl` | GLSL 4.60 / ESSL | `#version 450`, `layout(location = 0)`, `gl_Position`, `vec3`, `uniform` |
| Groovy | `groovy4` | Groovy 4 | named; closures, GString `"$x"`, `def`, Elvis `?:` |
| HLSL | `hlsl` | HLSL, Shader Model 6 (DXC) | `SV_POSITION`/`SV_TARGET` semantics, `Texture2D`, `register(t0)`, `SamplerState` |
| HLASM | `hlasm` | HLASM R6 (z/OS 3.1) | `CSECT`, `STM`/`LM`/`BR`, `USING`, `DC C'...'`, `//*` comments |
| JCL | `jcl` | z/OS 3.1 JCL | `//NAME JOB/EXEC/DD`, `//*` comments, `DISP=(NEW,CATLG)`, `SPACE=(CYL,(5,5))`, `PROC=` |
| Julia | `julia1` | Julia 1.x | named; `#= ... =#` block comments, `r"..."` raw strings, `1im` imaginary, `f(x, y=2; z=3)` |
| LLVM IR | `llvmir` | LLVM IR 17 | named; `define`/`declare`, `@globals`/`%locals`/`^labels`, `i32`, `icmp`/`br`/`ret`/`call`, `!dbg` |
| MATLAB | `matlab` | MATLAB R2024a | `%` + `%{ %}` comments, `...` continuation, `.'` transpose, `fprintf`, `end`-indexing |
| MLIR | `mlir` | MLIR (current dialects) | `func.func`, `tensor<4x8xf32>`, `%0 = arith.constant 0 : i32`, regions `{ ^bb0: }` |
| Nim | `nim2` | Nim 2 | named; `proc`, `var`, `#[ ... ]#` block comments, `defer`, `let` |
| ObjC | `objectivec` | Objective-C 2.0 | `@interface`/`@implementation`, message sends `[obj m:a]`, `@"..."` literals, `@[]`/`@{}` |
| Object Pascal | `objectpascal` | Object Pascal, Delphi 12 | `class ... end`, `procedure`/`function`, `begin`/`end`, `:=`, `{ $... }` directives |
| OCaml | `ocaml5` | OCaml 5 | named; `let ... in`, `function | ... ->`, variant types, `(* *)` comments |
| Prolog | `prolog` | Prolog ISO/IEC 13211-1 | `:-` clauses, `is`/`mod`, `\=`, `[H|T]` lists, `.` end, uppercase vars |
| REXX | `rexx` | REXX ANSI X3.274-1996 / ooRexx | `--` + `/* */` comments, `say`, `parse arg`, `do i = 1 to n ... end`, `||` concat |
| Scheme | `scheme` | Scheme R7RS | `define`, `let`/`cond`, `#t`/`#f`, `#\a` chars, `#| |#` block comments, `#xFF` |
| sed | `sed` | POSIX sed / GNU sed 4.x | `s/old/new/g` (any delimiter), addresses `1,10`/`$`/`/re/`, `:label`, `d`/`p`/`q`, `y///` |
| SystemVerilog | `systemverilog2017` | SystemVerilog-2017 (IEEE 1800-2017) | named; `class`, `always_ff`, `typedef`, `inside`, `<<< >>>`, `assert (...)` |
| Tcl | `tcl` | Tcl 8.6 | `proc`, `set`, `[...]` substitution, `{$...}` bracing, `foreach`, `expr {}` |
| VHDL | `vhdl2008` | VHDL-2008 (IEEE 1076-2008) | named; `entity`/`architecture`, `process` + `rising_edge`, `'1'` bits, `16#FF#`, `std_logic_vector` |
| VBA | `vba` | VBA 7.1 | `Sub`/`Function ... End`, `Dim x As T`, `'` comments, `For ... Next`, `Debug.Print` |
| Verilog | `verilog2005` | Verilog-2005 (IEEE 1364-2005) | named; `module`/`endmodule`, `always @(posedge clk)`, nonblocking `<=`, sized literals `4'hFF`, `` `define `` |
| WGSL | `wgsl` | WGSL (W3C WebGPU) | `@vertex`/`@fragment`, `vec4f`, `var<storage>`, hex-float `0x1.8p3`, `array<vec2f, 3>` |
| XSLT | `xslt30` | XSLT 3.0 | named; `<xsl:stylesheet version="3.0">`, `match` patterns, `select` XPath, AVT `{...}`, `xsl:function` |
| Zig | `zig014` | Zig 0.14 | named; `comptime`, `errdefer`/`orelse`, `?T` optionals, `@"builtin"`, `asm` |

Versioned data/query/config/infrastructure formats added in the same batches:
`plsql2023` (Oracle 23ai), `graphql` (Oct 2021), `rego1` (OPA Rego 1.x), `xpath31`,
`xquery31`, `jq1`, `toml` (1.0), `properties`, `csv` (RFC 4180), `cmake` (3.x),
`hcl2` (Terraform HCL 2), `starlark` (Bazel), `ninja`, `openapi3` (3.x, YAML form),
`pcre2` (PCRE2). These keep format names; their version is in the folder name where
the format is versioned.

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
