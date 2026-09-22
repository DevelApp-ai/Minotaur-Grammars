# Perl

Minotaur grammar for Perl, covering the core language subset.

## Syntax sketch

```
use strict;
use warnings;

sub greet {
  my ($name) = @_;
  print "Hello, $name!\n";
}
```

## AST validation goals

- use strict/warnings present at top
- sigils match context (scalar/array/hash)
- subroutine calls reference defined subs

Implements issue #67.

## Coverage completion

The grammar now also covers the remaining core language constructs:

- Ternary conditionals and postfix statement modifiers (`if`/`unless`/`while`/`for`)
- List and hash slices
- Regex binding (`=~`, `!~`) with `m//` matches
- Subroutine signatures
