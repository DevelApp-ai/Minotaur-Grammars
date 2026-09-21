# Requirements Specification (.srs, MoSCoW) grammar

Grammar for the SpecTree `.srs` requirements specification format with **MoSCoW prioritization** as a first-class field: every requirement carries exactly one of Must / Should / Could / Won't, a stable ID, optional acceptance criteria, and traceability links.

## File extension

`.srs`

## Syntax

```
# SRS: OrderPlatform
## Version: 1.0
### Must Have
- M-001: Orders must persist durably => order-service.ai
### Traceability
- M-001 -> order-service.ai
```

## AST validation goals

- Every requirement carries exactly one MoSCoW value (enforced by section membership)
- Every .ai component linked only to Won't requirements flagged as premature implementation
- Must requirements require Must-level .test coverage
- Release sanity: zero Must requirements, or an excessive Must-to-Should/Could ratio, is flagged (scope-stuffing)
- Traceability completeness: every requirement maps to at least one component spec; no orphan specs

## Origin

Defined in issue #98 (Specification-First Development grammar suite, umbrella issue #93). Based on the Specification-First Development analysis reports.
