# Contributing

Thanks for contributing a grammar to the Minotaur grammar library!

## Adding a grammar — checklist

1. **Pick the category** (`programming-languages/`, `natural-languages/`,
   `compiler-compilers/`, `postal-codes/`) and create a kebab-case folder,
   e.g. `programming-languages/my-language/`.
2. **Add the grammar file** with its original name, e.g. `MyLanguage.grammar`.
3. **Add `minotaur-metadata.json`** — copy the required fields from
   `schemas/minotaur-metadata.schema.json`. Key fields:
   - `Id`: `develapp.<name>` for DevelApp grammars, e.g. `develapp.csharp10`
   - `Vendor`: `DevelApp` for grammars authored here; the origin vendor for
     third-party grammars
   - `Version`: semver, start at `1.0.0`
   - `MainFile`: the grammar file name inside the folder
   - `PricingModel`: `"free"` by default
   - Natural-language grammars: tag as optional downloadable content via
     `Tags` (e.g. `"optional-download"`)
4. **Add `LICENSE`** — MIT for DevelApp-authored grammars; the origin license
   (with attribution) for grammars sourced elsewhere. See
   [docs/LICENSING.md](docs/LICENSING.md).
5. **Optional sidecars**: `*_Examples.txt` and `*_README.md` with example
   inputs and notes.
6. **Validate locally**:
   ```bash
   scripts/build-opa-input.sh
   opa eval -d policies -i opa-input.json 'data.minotaur'   # must be empty
   jq -e . your-folder/minotaur-metadata.json > /dev/null
   ```
7. **Open a PR** — CI runs schema validation, OPA license/metadata policies,
   and integration tests through ENFAStepLexer-StepParser on changed grammars.

## Rules of thumb

- Never add a repository-level license; licensing is per grammar.
- Never duplicate a grammar that already exists in another DevelApp repo —
  this repository is the single home for grammar definitions.
- Keep `MainFile` names stable; Minotaur's `ProjectLoader` maps legacy names
  to files in this repository.
