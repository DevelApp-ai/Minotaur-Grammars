# Unix ls Output

Minotaur grammar for Unix ls Output, covering the core language subset.

## Syntax sketch

```
-rw-r--r--  1 user  staff  4096 Sep 21 10:15 report.txt
drwxr-xr-x  2 user  staff    64 Sep 21  2025 docs
```

## AST validation goals

- permissions string is exactly 10 characters
- recent files show time, older files show year
- link count and size are numeric

Implements issue #82.
