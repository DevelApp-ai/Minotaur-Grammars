# Large Grammar Transport: Chunking and Stitching

Standard for transporting grammar files that exceed the practical size of
single-call commit APIs (e.g. the GitHub contents API, roughly 30-45KB per
call depending on escaping) — enabling any file size through numbered
chunks stitched by CI.

## Chunk naming standard

Chunks live in `.grammar-parts/` at the repository root, as **flat files**:

```
.grammar-parts/<target-path-with-__-separators>.part-NNN
```

Example — chunks for `programming-languages/java17/Java17.grammar`:

```
.grammar-parts/programming-languages__java17__Java17.grammar.part-000
.grammar-parts/programming-languages__java17__Java17.grammar.part-001
.grammar-parts/programming-languages__java17__Java17.grammar.part-002
```

Rules:

1. **3-digit zero-padded part numbers** (`.part-000`, `.part-001`, ...):
   lexicographic sort equals numeric order — no numeric parsing needed.
2. **Target path encoded with `__`** as directory separator; the chunk base
   name (everything before `.part-NNN`) is the complete target path.
3. **Chunks split on newline boundaries only** (~20KB target size):
   concatenating all parts in order is byte-exact — no separators, no
   re-encoding, no escape translation.
4. **Chunks are not grammars**: the `.part-NNN` suffix keeps them invisible
   to `find -name '*.grammar'` sanity checks and to the grammar index while
   they exist.

## Stitching

- `scripts/stitch-grammar-parts.sh` — stitches all chunk groups into their
  target files (byte-exact concatenation). `--clean` also deletes the
  parts after successful stitching.
- `.github/workflows/stitch-grammars.yml` — runs the stitcher on any push
  or PR that touches `.grammar-parts/**`, sanity-checks the stitched
  files (non-empty, `Grammar:` header present), and commits the result
  on push events.

## Workflow interplay (important)

A commit made by `GITHUB_TOKEN` inside a workflow **does not re-trigger
workflows**. Therefore:

1. Push chunks → stitch workflow runs, commits the stitched files.
2. The stitch commit itself does not re-run the validation suites — the
   **next** commit on the branch (any API commit, or a PR update) runs the
   grammar-validation suite against the stitched files.

For PRs, the workflow runs in stitch-only mode (no commit), so PR checks
validate the stitched result directly.

## Producer procedure

1. Split the target file into ~20KB newline-boundary chunks following the
   naming standard.
2. Push each chunk as a single-file commit (e.g. via the contents API).
3. The stitch workflow assembles the file; verify via `git fetch` that the
   stitched file is byte-identical to the original (this also proves no
   escape mangling occurred across chunks).
4. Follow-up commits re-run the full validation suite on the stitched file.
