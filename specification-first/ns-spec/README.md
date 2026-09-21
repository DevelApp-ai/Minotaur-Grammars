# Non-Functional Specification (.ns) grammar

Grammar for the SpecTree `.ns` non-functional specification format. All constraints are measurable and numeric: performance budgets, security controls, scalability/availability SLOs, plus compliance references — each optionally bound to a component scope and traced to an ADR.

## File extension

`.ns`

## Syntax

```
# NFR: OrderPlatform
## AppliesTo: solution
### Performance
- PERF-001 (latency): <= 50ms (p99 read latency) adr: ADR-0007
### Security
- SEC-001: encrypt: TLS1.3 adr: ADR-0002
```

## AST validation goals

- Measurable, numeric constraints only
- Conflicts between NFRs (e.g. security vs. latency) flagged
- Every .ns constraint traces to an accepted ADR
- Scope references point to declared components

## Origin

Defined in issue #99 (Specification-First Development grammar suite, umbrella issue #93). Based on the Specification-First Development analysis reports.
