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

License: AGPL-3.0 (as the Minotaur project).
