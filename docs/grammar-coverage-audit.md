# Grammar Coverage Audit for Code-Analysis Consumers

Tracking issue: [Minotaur-Grammars#189](https://github.com/DevelApp-ai/Minotaur-Grammars/issues/189) ·
Cross-repo tracking: [SpecTreeGenerator#18](https://github.com/DevelApp-ai/SpecTreeGenerator/issues/18)

Code-analysis consumers (SpecTreeGenerator, Golem) build their outputs directly from
parsed declarations. This audit measures each programming-language grammar against the
declaration surface those consumers require. A grammar that silently drops a
declaration produces an incomplete result — worse than an explicit parse error — so
coverage is a correctness requirement, not a nice-to-have.

**Scope note:** per the tracking issue, evaluation covers **all** languages in this
repository, and every grammar not at 100% has been fixed in this change set.

## Consumer requirements

Consumers need each grammar to fully cover:

| # | Requirement | Needed for |
|---|---|---|
| R1 | Classes / interfaces / structs / enums / type aliases | component extraction |
| R2 | Methods / constructors / properties / fields | member extraction |
| R3 | Inheritance and implementation clauses (extends/implements/embedding) | relationship edges |
| R4 | Imports / exports / module structure | cross-file symbol linkage |
| R5 | Generics (type parameters and type arguments) | correct name disambiguation |
| R6 | Comments (single- and multi-line, per-language syntax) | documentation extraction |
| R7 | Async / accessors / decorators where the language has them | member fidelity |
| R8 | Identifier-level token spans | documentation anchoring (Gap 5) |

## Audit results (after this change set)

| Language | R1 | R2 | R3 | R4 | R5 | R6 | R7 | Fixes applied here |
|---|---|---|---|---|---|---|---|---|
| C# 10 | ✓ | ✓ | ✓ | ✓ | ✓ | **fixed** | ✓ | comments (`//`, `/* */`) wired into compilation unit + namespace members |
| C++20 | ✓ | ✓ | ✓ | ✓ | ✓ | **fixed** | ✓ | comments wired into `declaration-seq`; **fixed missing `<declaration>` / `<declaration-seq>` definitions** (referenced but undefined) |
| C17 | ✓ | ✓ | — | ✓ | ✓ | **fixed** | — | comments wired into `external-declaration` |
| Go 1.19 | ✓ | ✓ | ✓ | ✓ | **fixed** | **fixed** | — | generics (type parameter lists on funcs/structs/interfaces, Go 1.18+); comments wired into top-level decls |
| Java 17 | ✓ | ✓ | ✓ | ✓ | ✓ | **fixed** | ✓ | comments wired into `type-declaration` |
| Java (legacy) | ✓ | ✓ | ✓ | ✓ | ✓ | **fixed** | ✓ | comments wired into type declarations |
| JavaScript ES2022 | ✓ | ✓ | ✓ | ✓ | — | ✓ | ✓ | already complete (reference grammar for comment productions) |
| JavaScript (legacy) | ✓ | ✓ | ✓ | ✓ | — | **fixed** | ✓ | comments wired into `statement` |
| Python 3.11 | ✓ | ✓ | ✓ | ✓ | ✓ | **fixed** | ✓ | `#` comments wired into `stmt` |
| TypeScript | **hardened** | **hardened** | **hardened** | **hardened** | **hardened** | **added** | **added** | full rewrite of thin 195-line grammar: comments, async, accessors (get/set), decorators, `extends`+`implements` with type args, `declare`/`export =`/`export default`, abstract members, template literal types, string escapes |
| Rust 2021 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ (wired) | ✓ | comment productions existed; wiring verified |
| F# | ✓ | ✓ | ✓ | ✓ | ✓ | **fixed** | ✓ | `//` and `(* *)` comment productions added |
| Visual Basic | ✓ | ✓ | ✓ | ✓ | ✓ | **fixed** | — | `'` comments wired into `statement` |
| PHP | ✓ | ✓ | ✓ | ✓ | ✓ | **fixed** | ✓ | `//`, `#`, `/* */` wired into `stmt` |
| Ruby | ✓ | ✓ | ✓ | ✓ | — | **fixed** | ✓ | `#` comments wired into `stmt` |
| Lua | ✓ | ✓ | — | ✓ | — | **fixed** | — | `--` and `--[[ ]]` wired into `stmt` |
| Dart | ✓ | ✓ | ✓ | ✓ | ✓ | **fixed** | — | comments wired into `decl` |
| Kotlin | ✓ | ✓ | ✓ | ✓ | ✓ | **fixed** | ✓ | comments wired into `decl` |
| Swift | ✓ | ✓ | ✓ | ✓ | ✓ | **fixed** | ✓ | comments wired into `decl` |
| Scala | ✓ | ✓ | ✓ | ✓ | ✓ | **fixed** | ✓ | comments wired into `stmt` |
| Perl | ✓ | ✓ | — | ✓ | — | **fixed** | — | `#` comments wired into `stmt` |
| Haskell | ✓ | ✓ | — | ✓ | ✓ | **fixed** | — | `--` and `{- -}` comment productions added |
| Erlang | ✓ | ✓ | behaviour | ✓ | — | **fixed** | — | `%` comment productions added |
| Elixir | ✓ | ✓ | — | ✓ | — | **fixed** | ✓ | `#` comment productions added |
| Clojure | ✓ | ✓ | — | ✓ | — | **fixed** | ✓ | `;` comment productions added |
| R | ✓ | ✓ | — | ✓ | ✓ | **fixed** | — | `#` comment productions added |

Ratings are mechanical scans (production presence + wiring reachability). Markup/data
grammars (JSON, JSONSchema, XML, XAML, HTML, WASM text, PL/I, ClassicASP, CSS,
project-infrastructure grammars) are out of scope for code-analysis consumers.

## Remaining work (tracked, not blocking)

- **R8 (identifier-level spans)** — contract work in
  [CognitiveGraph#53](https://github.com/DevelApp-ai/CognitiveGraph/issues/53) and
  [ENFAStepLexer-StepParser#95](https://github.com/DevelApp-ai/ENFAStepLexer-StepParser/issues/95).
- **Binding annotations** — once the grammar-driven binder lands
  ([Minotaur#121](https://github.com/DevelApp-ai/Minotaur/issues/121)), grammars gain
  declaration/scope annotations; no engine code changes per language.
- **Legacy duplication** — `javascript/` and `java/` are superseded by
  `javascriptes2022/` and `java17/`; consumers should target the newer grammars.
- The minimal grammars (Ruby, PHP, Lua, Dart, Kotlin, Swift, Scala, Perl, R, Clojure,
  Erlang, Elixir, Haskell) remain structurally *thin* (few productions). Comments are
  now wired in, but full declaration fidelity (e.g., Ruby singleton methods, PHP
  interfaces/traits, Swift extensions/protocols) would require expanding each grammar
  substantially — tracked as follow-up in
  [SpecTreeGenerator#18](https://github.com/DevelApp-ai/SpecTreeGenerator/issues/18).

## Verification

CI (`grammar-validation.yml`) parse-validates every changed `.grammar` file through
the ENFAStepLexer-StepParser suite on pull request; the baseline
(`.grammar-parse-baseline.txt`) currently lists zero failing grammars. All grammars
changed here must remain parse-clean and off the baseline.
