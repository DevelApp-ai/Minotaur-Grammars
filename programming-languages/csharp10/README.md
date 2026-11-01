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
conformance harness.

Known limitations of the lexing layer:

- `/* ... */` block comments are not tokenized (the terminator cannot be
  matched without backtracking in the supported regex subset).
- String literals with escaped quotes lex with shifted token boundaries.

Full C# parse coverage remains tracked in Minotaur-Grammars issue #194.
