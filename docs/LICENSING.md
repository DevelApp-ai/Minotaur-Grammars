# Licensing Guide

This repository has **no repository-level license**. Licensing is a per-grammar
property: every grammar folder carries its own `LICENSE` file, and the license
is recorded in that grammar's `minotaur-metadata.json` under the `License`
field as an [SPDX identifier](https://spdx.org/licenses/).

## Policy

| Origin | License |
| --- | --- |
| Authored by DevelApp / Lars Buch | **MIT** (SPDX: `MIT`) |
| Sourced from elsewhere | The **origin license**: keep its SPDX identifier, copy the origin license text into the folder's `LICENSE`, and attribute the original author |

There is deliberately no top-level `LICENSE` file — a grammar's license must
stand alone so the grammar can be packaged and distributed through
Minotaur-Marketplace without repository context.

## Rules

1. Every grammar folder **must** contain a `LICENSE` file.
2. `minotaur-metadata.json` → `License` must be a valid SPDX identifier and must
   match the `LICENSE` file.
3. DevelApp-authored grammars are always `MIT` — no exceptions.
4. Third-party grammars must carry an allowed origin license and document the
   origin (see the grammar folder's README or metadata `Documentation` field).

## Allowed SPDX identifiers

DevelApp grammars use `MIT`. Third-party grammars may use any of the
allow-listed identifiers in `policies/minotaur/license.rego` (MIT, MIT-0,
Apache-2.0, BSD-2-Clause, BSD-3-Clause, ISC, MPL-2.0, EPL-2.0, GPL-2.0-only,
GPL-3.0-only, LGPL-2.1-only, LGPL-3.0-only, AGPL-3.0-only, Unlicense, CC0-1.0).
To allow another identifier, add it to `allowed_spdx` in that policy — the
policy file is the single source of truth for CI validation.

## How to add a license to a grammar

1. If you authored the grammar for DevelApp: add the MIT license text as
   `LICENSE` with an `SPDX-License-Identifier: MIT` line at the top.
2. If the grammar originates elsewhere: copy the **origin license text**
   verbatim into `LICENSE` (with an `SPDX-License-Identifier: <id>` line),
   and credit the original author in the file header and in the grammar's
   README.
3. Set `"License": "<SPDX-ID>"` in `minotaur-metadata.json`.
4. Run `scripts/build-opa-input.sh` and then
   `opa eval -d policies -i opa-input.json 'data.minotaur'` — the result must
   be an empty set of violations.

## Validation

Licensing is validated by the OPA/Rego policies in `policies/` (see
`docs/STRUCTURE.md`), which are shared with the Minotaur and
Minotaur-Marketplace repositories so on-publish validation uses the exact same
rules.
