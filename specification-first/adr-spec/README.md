# Architectural Design Record (.adr) grammar

Grammar for the SpecTree `.adr` architectural design record format: YAML front-matter (`id`, `status` lifecycle proposed→accepted→deprecated/superseded, `supersedes`, `related_requirements`), Context / Decision / Consequences / Alternatives sections, and component compliance declarations.

## File extension

`.adr`

## Syntax

```
---
id: ADR-0001
title: Use Terraform for IaC
status: accepted
date: 2024-01-15
supersedes: []
related_requirements: [M-001]
---
# ADR-0001 Use Terraform for IaC
## Decision
Adopt Terraform >= 1.5.
## Compliance
- component: OrderService must conform
```

## AST validation goals

- No orphan references: ADRs referenced by .ai/.ns specs exist and are accepted
- Superseded ADRs not referenced by active component specs
- Every architectural constraint in .ns files traces to an accepted ADR
- Conflicting decisions (two accepted ADRs mandating incompatible approaches) detected

## Origin

Defined in issue #101 (Specification-First Development grammar suite, umbrella issue #93). Based on the Specification-First Development analysis reports.
