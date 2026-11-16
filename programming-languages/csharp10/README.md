# CSharp10 grammar

C# 10 grammar (EBNF) for the Minotaur parser platform. `CSharp10.grammar` is
the main file; `Labyrinth.extension` is an optional overlay.

## Lexing layer (issue #194)

The grammar carries a token-rule layer (keywords, identifiers, literals,
operators, punctuation, `//` comments, whitespace) so the StepLexer can lex
real C# to completion. Where C# would need alternation, several same-named
token rules provide alternative spellings of one token type (the runtime
matcher has no groups/alternation/anchors). `Conformance.txt` declares the
`lex:`/`fail:` cases CI runs against this grammar through the ENFA
conformance harness. Covered by the token layer: digit separators
(`1_000_000`, `0xDEAD_BEEF`, `0b1010_1010`), char escape sequences
(`'\n'`, `'\u0041'`, `'\x41'`, `'\''`, `'\\'`), and raw string literals
without interior quotes (`"""..."""`).

Known limitations of the lexing layer (engine-capability gaps in the
upstream ENFAStepLexer-StepParser, not grammar omissions):

- `/* ... */` block comments are not tokenized (the terminator cannot be
  matched without within-rule alternation in the supported regex subset).
- String literals with escaped quotes lex with shifted token boundaries.
- Verbatim strings with doubled quotes and raw strings with interior
  quotes need the same within-rule alternation construct.

Full C# parse coverage remains tracked in Minotaur-Grammars issue #194.
