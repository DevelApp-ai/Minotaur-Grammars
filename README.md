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

## Release packaging

Cutting a release is `git tag v1.0.0 && git push origin v1.0.0`. The
[release pipeline](.github/workflows/release-grammars.yml) then:

1. runs the same sanity checks and OPA license/metadata policies as CI
   (including an input-completeness assertion, so a truncated policy input
   can never evaluate to a fake "violation-free"),
2. waits for the ENFA parse-validation gate on the tagged commit
   (`grammar-validation.yml` also triggers on `v*` tags),
3. packages **every grammar folder** (all categories except
   `test-grammars/`) as a byte-deterministic `tar.gz` with
   [scripts/package-grammars.sh](scripts/package-grammars.sh)
   (sorted entries, fixed mtime/owner/mode, `gzip -n` — identical bytes on every
   machine),
4. signs `SHA256SUMS` and `release-manifest.json` with cosign keyless OIDC
   (org decision #14; identity-pinned to `https://github.com/DevelApp-ai/`)
   and verifies both signatures in-job,
5. creates the GitHub release with all grammar tarballs plus `SHA256SUMS`
   and `release-manifest.json` (each with `.sig`/`.bundle` sidecars).

A `workflow_dispatch` run of the same pipeline is a **dry run**: it packages
and signs but uploads the result as a workflow artifact instead of creating
a release.

Consumers verify a download against the signed checksum file:

```bash
sha256sum -c SHA256SUMS --ignore-missing
cosign verify-blob \
  --bundle SHA256SUMS.bundle \
  --certificate-identity-regexp '^https://github.com/DevelApp-ai/' \
  --certificate-oidc-issuer https://token.actions.githubusercontent.com \
  SHA256SUMS
```

`GrammarPackageExporter` in the Minotaur repository is still a placeholder
(its tar writer does not yet produce a valid tar stream), so this pipeline
is the byte-accurate producer of the marketplace-format `tar.gz` packages
until it is real; the marketplace publish step (issue #26) will consume
these release assets.

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
- Coverage: **every language grammar under `programming-languages/`** ships
  the overlay (36 grammars: c17, classicasp, clojure, cobol2023, cpp20,
  csharp10, css, dart, elixir, erlang, fsharp, go119, haskell, htmlembedded,
  java, java17, javascript, javascriptes2022, json, jsonschema, kotlin, lua,
  perl, php, pl1, python311, r, ruby, rust2021, scala, swift, typescript,
  visualbasic, webassembly20, xaml, xml). Only the meta/project grammars
  (`extensionfile`, `folderproject`, `grammarfile`, `sample`, `dotnetproject`)
  are excluded — they describe Minotaur project formats, not languages.

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
