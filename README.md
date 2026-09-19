# Minotaur-Grammars

The grammar library for [Minotaur](https://github.com/DevelApp-ai/Minotaur), the compiler-compiler platform.

This repository holds the grammar definitions previously bundled in the Minotaur
engine repository under `grammars/`:

- **Programming-language grammars** (C#, C/C++, Java, JavaScript, TypeScript, COBOL, PL/I, Rust, Go, CSS, SQL, and more)
- **Natural-language grammars** (Danish, German, French, Latin, Ancient Greek, Faroese, and more) — optional downloadable content, useful for multilingual parsing demos and testing the grammar format
- **Compiler-compiler base grammars** (ABNF, CEBNF, ...)
- **Postal-code grammars** (`PostalCodes/`) with tests

## Usage

Grammars are consumed by the Minotaur engine. Clone or download this repository
when you need grammar definitions; the Minotaur engine repository itself stays
focused on the compiler-compiler platform code.

## Structure

- `*.grammar` — grammar definitions
- `*_Examples.txt` — example inputs for the corresponding grammar
- `*_README.md` — notes for the corresponding grammar
- `PostalCodes/` — postal-code grammars and their tests
- `sample.grammar` — sample grammar demonstrating context-sensitive projections and semantic rules (imported from [ENFAStepLexer-StepParser](https://github.com/DevelApp-ai/ENFAStepLexer-StepParser))

## Licensing

There is **no repository-level license**. Licensing is a **per-grammar property**:

- Grammars authored by DevelApp / Lars Buch are **MIT** licensed.
- Grammars originating elsewhere follow their **origin license** (see the individual grammar folder / metadata once the per-grammar licensing work lands).

See the [licensing tracking issue](https://github.com/DevelApp-ai/Minotaur-Grammars/issues/1) for details.
