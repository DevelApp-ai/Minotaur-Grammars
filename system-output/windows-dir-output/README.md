# Windows dir Output

Minotaur grammar for Windows dir Output, covering the core language subset.

## Syntax sketch

```
 Volume in drive C has no label.
 Directory of C:\Users\lars
09/21/2026  10:15 AM    <DIR>          .
09/21/2026  10:15 AM             4,096 notes.txt
```

## AST validation goals

- each entry has date, time, and either <DIR> or byte size
- footer totals are numeric
- paths use drive-letter form

Implements issue #83.

## Extended coverage

Adds junction/symlink markers, volume serial numbers, comma-grouped numbers, and ISO-style dates.
