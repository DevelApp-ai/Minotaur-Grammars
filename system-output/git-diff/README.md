# Git Diff

Minotaur grammar for Git Diff, covering the core language subset.

## Syntax sketch

```
diff --git a/app.ts b/app.ts
index 1234567..89abcde 100644
--- a/app.ts
+++ b/app.ts
@@ -1,3 +1,4 @@
 const a = 1;
+const b = 2;
 const c = 3;
```

## AST validation goals

- hunk headers have matching - and + ranges
- added and removed line counts match the hunk header
- each file diff has --- and +++ paths

Implements issue #86.

## Extended coverage

Adds new/deleted file modes, rename detection, binary file notices, and old/new mode lines.
