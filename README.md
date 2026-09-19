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
