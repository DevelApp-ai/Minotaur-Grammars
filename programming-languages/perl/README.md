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

## Extended coverage

Adds packages with bless, references and arrow dereferencing, unless/until, heredocs, POD documentation, and loop control statements.
