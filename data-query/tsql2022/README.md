# TSQL2022

Minotaur grammar for T-SQL (SQL Server 2022) DDL, hand-authored for the
ENFAStepLexer-StepParser engine and validated against machine-generated
T-SQL: the JsonSchemaBuilder (jsb) TSQL generator corpus (21 files:
`Default/` + `Funny/Onion/`), all passing with contiguous byte coverage
under `LexingMode.GreedyLongestMatch`.

## Why a new grammar

Replaces the removed `data-query/sql/` grammar (issue #77, closed without
a versioned replacement). PHP and SQL grammars are now versioned like the
rest of the repository. The ANSI core lives in `data-query/sql2023/`.

## Validation scope

A **disciplined DDL subset**: the exact statement shapes jsb's TSQL
(Database First) generator emits. It is the right tool for validating jsb
TSQL output; it is NOT a general-purpose T-SQL grammar.

### Included

- `IF NOT EXISTS (SELECT 1 FROM sys.schemas WHERE name = N'...')
  EXEC(N'CREATE SCHEMA [x];');` schema-prologue unit
- `IF OBJECT_ID(N'[s].[t]', N'U') IS NOT NULL DROP TABLE [s].[t];`
  drop-guard unit
- `CREATE TABLE [schema].[Name] ( ... );` units (1-8 batches per script,
  each ending with the `GO` batch separator)
- `--` and `/* */` comments
- `[Bracketed]` identifiers, `N'...'` national and `'...'` string literals
- Column types: `BIGINT` (incl. `IDENTITY(1,1)`), `BIT`, `DATE`, `TIME`,
  `DATETIMEOFFSET`, `NVARCHAR(MAX)`, `NVARCHAR(n)`
- Column constraints: `NULL`, `NOT NULL`, `DEFAULT 'literal'` /
  `DEFAULT N'literal'`, `CHECK (expr)`
- CHECK expressions: `[col] IN (N'a', N'b', N'c', N'd')` (1-4 values) and
  function comparisons `LEN([col]) >= n`
- Named table constraints: `CONSTRAINT [PK_x] PRIMARY KEY ([Id])`,
  `CONSTRAINT [FK_x] FOREIGN KEY ([ParentId]) REFERENCES [s].[t] ([Id])`
- Any number of columns/constraints per table (left-recursive list)

### Excluded (documented, by design)

- DML (INSERT/UPDATE/DELETE/SELECT beyond the schema-prologue subquery),
  stored procedures, views, indexes, triggers, ALTER statements
- Unnamed table constraints; inline column-level PRIMARY KEY/FOREIGN
  KEY/UNIQUE/REFERENCES
- Other type names (INT, DECIMAL, FLOAT, DATETIME2, UNIQUEIDENTIFIER,
  VARCHAR for TSQL, ...) — add forms as the generator emits them
- Variable declarations (`DECLARE @v`), SET, control flow beyond the two
  IF-guard unit shapes, EXEC with non-literal arguments
- `ON DELETE`/`ON UPDATE` cascade clauses; computed/persisted columns;
  sparse columns; storage clauses; mixed-case keywords

## Engine-discipline notes

Same disciplines as `php85/` (see that README): enumerated root counts
(`sql_script` = 1-8 `batch_unit`s instead of a list, which eliminates a
score-tied base/merge fork that evicted the correct path on 5+-batch
files), left-recursive column lists, literal- and symbol-named fold forms
for `IDENTITY` columns, and no comment lines inside the grammar file.

Implements the SQL half of issues #58 / #77 (versioned PHP/SQL grammars).
