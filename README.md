# Minotaur-Grammars

The consolidated grammar library for the DevelApp ecosystem. This repository
is the **single home for grammar definitions** used by
[Minotaur](https://github.com/DevelApp-ai/Minotaur),
[ENFAStepLexer-StepParser](https://github.com/DevelApp-ai/ENFAStepLexer-StepParser),
and grammars distributed via **Minotaur-Marketplace**.

## Layout

Every grammar lives in its own folder with its metadata and license, grouped
by category (`programming-languages/`, `natural-languages/`,
`compiler-compilers/`, `postal-codes/`). See
[docs/STRUCTURE.md](docs/STRUCTURE.md) for the full layout and file-by-file
reference.

## Licensing

There is **no repository-level license**. Each grammar folder carries its own
`LICENSE`: DevelApp-authored grammars are MIT; grammars sourced elsewhere
keep their origin license with attribution. See
[docs/LICENSING.md](docs/LICENSING.md).

## Marketplace distribution

Minotaur-Marketplace is the distributor for all grammars in this repository.
Each grammar is packaged (tar.gz) with a `minotaur-metadata.json` matching the
marketplace `GrammarInfo` schema:

- Schema: [schemas/minotaur-metadata.schema.json](schemas/minotaur-metadata.schema.json)
- A grammar that validates against the schema and the OPA policies can be
  packaged with `GrammarPackageExporter` and published with zero manual edits.

## Labyrinth rule patterns (`Labyrinth.extension`)

Grammars that can serve as **target grammars for Labyrinth rules** (Minotaur's
SAST rule engine) may ship an optional `Labyrinth.extension` overlay next to
the `.grammar` file:

```
programming-languages/csharp10/
  CSharp10.grammar
  Labyrinth.extension   <- optional
```

The overlay adds the Labyrinth pattern operators (`$NAME` metavariable,
`...` ellipsis) on top of the base grammar via StepParser overlay composition
(Minotaur-Grammars issue #184; engine support in
DevelApp-ai/ENFAStepLexer-StepParser#65, #66 and DevelApp-ai/Minotaur#88).
It uses the same file format as the `extensions/*.extension` files, so one
mechanism covers both.

- **Optional**: a grammar without a `Labyrinth.extension` loads and works
  unchanged; absence is not an error.
- **Fixed name**: always `Labyrinth.extension`, so consumers can discover it
  without a manifest change.
- **Metadata**: grammars shipping the overlay set `"LabyrinthExtension": true`
  in their `minotaur-metadata.json`, so tooling can filter Labyrinth-capable
  grammars without hitting the filesystem.
- Initial target grammars: csharp10, typescript, javascriptes2022, python311,
  java17, go119, rust2021, cpp20 — others can follow incrementally.

## Validation

```bash
# Build the OPA input document from the grammar folders
scripts/build-opa-input.sh

# License + metadata policies (must return an empty violation set)
opa eval -d policies -i opa-input.json 'data.minotaur'

# Policy unit tests
opa test policies
```

The OPA policies are intentionally minimal: they check licensing and metadata
completeness. Grammar correctness is proven by integration tests that load and
parse the grammars through ENFAStepLexer-StepParser in CI.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for the step-by-step checklist for
adding a grammar.
