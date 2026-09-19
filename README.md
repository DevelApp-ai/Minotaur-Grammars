# Minotaur-Grammars

The grammar library for [Minotaur](https://github.com/DevelApp-ai/Minotaur), the compiler-compiler platform.
This is the single, consolidated home for grammar definitions across the DevelApp ecosystem:
used by Minotaur, by [ENFAStepLexer-StepParser](https://github.com/DevelApp-ai/ENFAStepLexer-StepParser)
(test/sample grammars), and distributed to end users via Minotaur-Marketplace.

## Structure

Every grammar lives in its own directory, grouped by category — original file
names are preserved inside the folders:

```
programming-languages/<grammar>/<Name>.grammar
natural-languages/<grammar>/<Name>.grammar        # optional downloadable content
compiler-compilers/<grammar>/<Name>.grammar       # ANTLR/bison/yacc/flex/lex bases, ABNF/CEBNF/MBNF
postal-codes/<grammar>/<Name>.grammar             # with tests where available
test-grammars/                                    # grammars consumed by ENFAStepLexer-StepParser tests
```

- Each grammar directory can contain `<Name>.grammar`, example inputs
  (`<Name>_Examples.txt`), and notes (`<Name>_README.md`).
- `grammars.json` — machine-readable index of every grammar (name, category,
  path). Use it to resolve a grammar name to its location.
- `test-grammars/step-parser-tests/<TestClass>/<GrammarName>.grammar`,
  `test-grammars/benchmarks/`, `test-grammars/demo/` — consumed by
  ENFAStepLexer-StepParser; numbered variants are distinct grammars sharing a
  name across test methods (some are deliberately invalid error-path fixtures).

## Usage

Grammars are data files fetched on demand (e.g. via raw.githubusercontent.com
or a local checkout). Minotaur's tests and ENFAStepLexer-StepParser's test
suite both consume this repository directly; CI in this repository validates
grammar changes by running the ENFAStepLexer-StepParser integration suite.

Natural-language grammars are **optional downloadable content** — part of
Minotaur's product direction for parsing documentation and preparing LLM
training data with semantic understanding as first-level data. They are never
bundled with the engine.

## Licensing

There is **no repository-level license**. Licensing is a **per-grammar property**:

- Grammars authored by DevelApp / Lars Buch are **MIT** licensed.
- Grammars originating elsewhere follow their **origin license**.

See the [licensing tracking issue](https://github.com/DevelApp-ai/Minotaur-Grammars/issues/1) for details.
