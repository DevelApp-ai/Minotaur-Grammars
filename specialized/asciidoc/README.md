# AsciiDoc

Minotaur grammar for AsciiDoc, covering the core language subset.

## Syntax sketch

```
= Document Title
:toc: left

== Section

An *important* _note_ here.

[NOTE]
====
Remember this.
====
```

## AST validation goals

- section levels nest monotonically
- tables are delimited by |=== pairs
- attribute entries use :name: form

Implements issue #89.
