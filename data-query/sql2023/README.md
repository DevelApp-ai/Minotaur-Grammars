# SQL2023

Minotaur grammar for ANSI SQL:2023 DDL, hand-authored for the
ENFAStepLexer-StepParser engine and validated with a strict
coverage-checked harness (every input byte must be consumed by the parse
or a skip rule) under `LexingMode.GreedyLongestMatch`.

## Why a new grammar

Replaces the removed `data-query/sql/` grammar (issue #77, closed without
a versioned replacement). PHP and SQL grammars are now versioned like the
rest of the repository. The TSQL dialect lives in `data-query/tsql2022/`;
this grammar covers the ANSI core.

## Validation scope

This grammar is **probe-verified** (the `Examples.txt` ANSI corpus and
Conformance.txt probes PASS under the coverage-checked harness), NOT
corpus-verified: the jsb TSQL generator output is T-SQL, not ANSI
(`IF NOT EXISTS ... EXEC(N'CREATE SCHEMA ...') GO` prologues, `IF
OBJECT_ID ... DROP TABLE` guards, `IDENTITY(1,1)`, `NVARCHAR(n)`,
`DEFAULT N'...'`) and belongs to `data-query/tsql2022/`, which validates
that corpus 21/21. sql2023 covers the ANSI core those files don't use.

A **disciplined DDL subset**: the `CREATE TABLE` shapes JsonSchemaBuilder
schemas conceptually map to in ANSI SQL, plus named table constraints. It
is the right tool for validating generated ANSI DDL; it is NOT a
general-purpose SQL grammar (no DML, no queries, no procedural SQL).

### Included

- `CREATE TABLE` statements (1-8 per script), `--` and `/* */` comments
- Delimited (`"name"`, `"schema"."name"`) and plain identifiers
- Column types: `BIGINT`, `BIT`, `DATE`, `TIME`, `TIMESTAMP`,
  `VARCHAR(n)`, `CHAR(n)`
- Column constraints: `NULL`, `NOT NULL`, `DEFAULT 'literal'`,
  `CHECK (expr)`
- Named table constraints: `CONSTRAINT name PRIMARY KEY (col)`,
  `CONSTRAINT name UNIQUE (col)`,
  `CONSTRAINT name FOREIGN KEY (col) REFERENCES "s"."t" (col)`,
  `CONSTRAINT name CHECK (expr)`
- CHECK expressions: `col IN ('a', 'b', 'c', 'd')` (1-4 values) and
  function comparisons `fn(col) >= n`

### Excluded (documented, by design)

- Unnamed table constraints (`PRIMARY KEY (col)` without `CONSTRAINT
  name`): adding them makes the grammar ambiguous enough that the
  engine's 10-path GLR budget can evict the correct parse on deep
  inputs; jsb always emits named constraints
- DML (INSERT/UPDATE/DELETE/SELECT), MERGE, CTEs, triggers, procedures,
  grants
- Table-level `CHECK` with subqueries; DEFAULT with non-literal
  expressions; COLLATE; storage clauses
- Mixed-case keyword tolerance (keywords are uppercase, like the corpus)

## Engine-discipline notes

Same disciplines as `php85/` (see that README): enumerated root counts
(`sql_script` = 1-8 statements), left-recursive column lists, keyword
anchoring, no comment lines inside the grammar file, and multi-alternative
single-type rules written on one line (a single-quoted-literal production
rule would be classified as a token rule).

Implements the SQL half of issues #58 / #77 (versioned PHP/SQL grammars).
