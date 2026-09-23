# Repository Structure

Each grammar lives in its own folder, grouped by category:

```
programming-languages/       # grammars for programming & markup languages
  csharp10/
    CSharp10.grammar         # the grammar itself (MainFile)
    minotaur-metadata.json   # marketplace metadata (GrammarInfo)
    LICENSE                  # per-grammar license (see docs/LICENSING.md)
    CSharp10_Examples.txt    # optional sidecar: example inputs
    CSharp10_README.md       # optional sidecar: grammar notes
    Labyrinth.extension      # optional: Labyrinth (SAST) pattern-operator overlay
natural-languages/           # natural-language grammars (optional
  danish/                    #   downloadable content in the marketplace)
compiler-compilers/          # base grammars other grammars inherit from
  antlr4-base/               #   (e.g. antlr4_base, yacc_base, flex_base)
postal-codes/                # postal-code grammars
  us-postal-code/
    US_Postal_Code.grammar
    Tests/                   # grammar-specific test inputs
schemas/
  minotaur-metadata.schema.json   # JSON Schema for minotaur-metadata.json
policies/                    # OPA/Rego validation policies (shared with
  minotaur/                  #   Minotaur and Minotaur-Marketplace)
scripts/
  build-opa-input.sh         # builds opa-input.json for policy evaluation
docs/
  LICENSING.md               # per-author licensing policy
  STRUCTURE.md               # this document
```

## Conventions

- **Folder names** are kebab-case (e.g. `us-postal-code`, `antlr4-base`).
- **Grammar file names** keep their original names (e.g. `CSharp10.grammar`);
  `MainFile` in the metadata points at the file inside the folder.
- **Sidecars** (`*_Examples.txt`, `*_README.md`) move into the corresponding
  grammar folder.
- A grammar folder is any directory containing a `minotaur-metadata.json` —
  this is also how the validation scripts discover grammars.
- **`Labyrinth.extension`** is an optional fixed-name overlay marking a
  grammar as a Labyrinth (Minotaur SAST) target grammar; a grammar without
  it must load and work unchanged (issue #184).

## What each file is

| File | Purpose |
| --- | --- |
| `<Name>.grammar` | The grammar definition consumed by Minotaur / ENFAStepLexer-StepParser |
| `minotau

r-metadata.json` | Marketplace package metadata; validates against `schemas/minotaur-metadata.schema.json` |
| `LICENSE` | Per-grammar license text with an `SPDX-License-Identifier:` line |
| `*_Examples.txt` | Sample inputs exercising the grammar |
| `*_README.md` | Notes about the grammar (coverage, origin, quirks) |
| `Tests/` | Grammar-specific test cases |
| `Labyrinth.extension` | Optional Labyrinth (SAST) pattern-operator overlay; presence is also flagged as `"LabyrinthExtension": true` in `minotaur-metadata.json` (issue #184) |

## Validation

```bash
scripts/build-opa-input.sh
opa eval -d policies -i opa-input.json 'data.minotaur'
opa test policies
```

Grammar *correctness* is not checked by OPA; the CI pipeline validates
metadata and licensing here, and loads/parses changed grammars through
ENFAStepLexer-StepParser integration tests.

## Test grammars

`test-grammars/` holds the grammars extracted from ENFAStepLexer-StepParser
(tests, benchmarks, demo; see issue #9). These folders follow the same
per-grammar layout as the categories above — each contains a
`minotaur-metadata.json` (tagged `test-grammar`) and a MIT `LICENSE` —
so they are discoverable and validated by the same OPA policies and scripts.
They are test fixtures rather than marketplace content: some deliberately
describe invalid or malformed grammars (error-path tests), which is fine
because OPA validates metadata and licensing, not grammar semantics.

| Subfolder | Consumer |
| --- | --- |
| `test-grammars/step-parser-tests/<TestClass>/` | `DevelApp.StepParser.Tests` (`TestGrammars.Get`) |
| `test-grammars/benchmarks/ParserBenchmarks/` | `DevelApp.Benchmarks` |
| `test-grammars/demo/StepParserDemo/` | `ENFAStepLexer.Demo` |

## Specification-first grammars (SpecTree)

specification-first/           # SpecTree formats for Specification-First
                               # Development (see umbrella issue #93)
  ai-spec/                     # .ai component specifications (#94)
  test-spec/                   # .test test specifications (#95)
  api-spec/                    # .api interface specifications (#96)
  model-spec/                  # .model data model specifications (#97)
  srs-spec/                    # .srs requirements with MoSCoW (#98)
  ns-spec/                     # .ns non-functional specifications (#99)
  solution-manifest/           # spec-to-.NET-solution binding (#100)
  adr-spec/                    # .adr architectural design records (#101)

These follow the same per-grammar layout as the other categories, using the
normalized sidecar names `README.md` and `Examples.txt`.
