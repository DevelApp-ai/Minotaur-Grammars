# JSONSchemaDraft7

Minotaur grammar for JSON Schema draft-07, hand-authored for the
ENFAStepLexer-StepParser engine and validated against machine-generated
schemas: the JsonSchemaBuilder (jsb) corpus (21 files: `Default/` +
`Funny/Onion/`), all passing with contiguous byte coverage under
`LexingMode.GreedyLongestMatch`.

## Why a new grammar

The existing `programming-languages/jsonschema/JSONSchema.grammar` is a
general draft-2020-12 grammar; it passed 9/21 of the jsb corpus files
(issue #220). jsb emits draft-07 (`$schema`
`http://json-schema.org/draft-07/schema#`), so this grammar is a
versioned, jsb-disciplined draft-07 grammar; the existing general grammar
is untouched.

## Validation scope

The grammar is a **disciplined subset**, not full draft-07. It accepts the
schema shapes jsb emits and rejects everything else. It is the right tool
for validating jsb output; it is NOT a general-purpose draft-07 grammar.

### Included

- Draft-07 document: single root object schema (`$schema`, `$id`, ...)
- Keyword members: `title`, `description`, `$comment`, `examples` (`[]`),
  `enum` (0-3 string items), `type`, `format`, `maxLength`/`minLength`
  (integers), `pattern`, `items` (single object schema),
  `additionalProperties: false`, `$ref`, `required` (0-7 string items)
- `properties`/`definitions` maps with 1-9 entries; entries accept any
  key token (see keyword collision note below)
- `allOf`/`anyOf`/`oneOf` composition lists (0-3 nested schemas)
- Type values: `string`, `object`, `array`, `integer`, `boolean`
- Format values: `date`, `date-time`, `time`, `email`, `iri-reference`
- Nested schemas to corpus depth (4 levels of object nesting, 12 members
  per schema object)
- Quoted strings with escapes; regex-valued `pattern` strings

### Excluded

- Schema member counts beyond 12, `properties`/`definitions` entries
  beyond 9, `enum` beyond 3, `required` beyond 7, composition lists
  beyond 3 (all corpus maxima)
- `true` as a schema value; numeric `maxLength`/`minLength` are integers
  only, no floats anywhere (jsb emits none)
- `enum`/`required` list items that collide with keyword tokens
  (see below); only quoted-string items lexed as `json_string` are
  accepted
- Other draft-07 keywords (`multipleOf`, `exclusiveMaximum`,
  `dependencies`, `if`/`then`/`else`, `contains`, `propertyNames`,
  `const`, `contentMediaType`, ...); draft 2019-09/2020-12 vocabulary
  (`$defs`, `prefixItems`, `unevaluatedProperties`, ...)

### Keyword collision note

jsb derives `properties` entry keys from C# property names, which can
collide with draft-07 keyword tokens (`"description"` as a property key
occurs in the corpus). The lexer resolves such strings to the keyword
token, so `<prop_entry>` accepts every token that can lexically start an
entry key (`json_string`, all member keywords, type values, format
values, `false`). Inside `enum`/`required` lists only `json_string`
items are accepted: generalizing those with a singleton item rule
(`item ::= token`) mis-fires through the engine's no-lookahead reduction
check and destroys the parse (verified empirically), so a jsb enum value
or required entry that lexes as a keyword is a documented exclusion.

## Engine-discipline notes (why the grammar looks like this)

The grammar is written against known engine behaviors of
DevelApp.StepParser 1.75.0. These are working disciplines, and also
upstream engine findings worth fixing in ENFAStepLexer-StepParser:

1. **Separator-shift via stack prefix**: a token is shiftable mid-rule
   only when the symbols before it already sit on the stack top. Member
   sequences therefore enumerate `member ',' member ...` (1-12) and
   `prop_seq` enumerates `prop_entry ',' prop_entry ...` (1-9): the
   unreduced chain survives and the delimiter (`,` vs `}`) decides when
   to reduce.
2. **No-lookahead reductions create fold twins**: `CanApplyReduction`
   matches the stack top against each rule's reversed RHS with no
   lookahead, so a left-recursive list (`seq ::= seq ',' item | item`)
   forks an immortal `seq ','`-layered twin at every item that shifts
   every later separator and crowds out the correct path. Sequences are
   enumerated instead of left-recursive. Singleton-token rules
   (`item ::= token`) mis-fire on every value on the stack and are
   avoided for the same reason.
3. **Merge dedup by (TokenPosition, stack signature)**:
   `MergeParserPaths` keys paths by consumed-token *count* plus stack
   shape, not by which tokens were consumed. Two different derivations
   of the same length collide and the wrong one can survive (seen as a
   completed `schema_document` stuck at an inner `}`). Keeping the
   correct path strictly ahead in consumed tokens avoids the collision.
4. **Resting depth-1 paths**: any depth-1 path survives arbitrary tokens
   without consuming them, so a validator must check contiguous
   consumption of the winning path, not just "a completed path exists"
   (the jsb corpus harness does; flat-file passes through skip-prefix
   junk paths are otherwise possible).
5. **Root rules only reduce at end of input** (engine issue #80);
   `<schema_document>` is the only root.
6. **Path budget (10)**: the parser keeps 10 GLR paths, pruned by
   (TokenPosition, Score). Nested `{` opens are universally shiftable
   (any `{` starts `<schema>`), which forks mirror paths at every
   object open; the corpus's nesting depth (4) keeps junk families
   below the budget, but deeper nesting may evict the correct path.

Implements the JSONSchema half of issue #220 (jsb corpus coverage).
