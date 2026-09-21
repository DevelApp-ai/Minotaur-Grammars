# Data Model Specification (.model) grammar

Grammar for the SpecTree `.model` data model specification format. Declares entities, value objects and enums with .NET type mappings, relationships with cardinality, invariants, and persistence hints (keys, indexes) for EF-compatible generation.

## File extension

`.model`

## Syntax

```
# Model: Orders
### Entities
- entity Order extends AggregateRoot
  - Id: Guid key
  - Status: OrderStatus required
### Relationships
- Order 1-* OrderItem
### Invariants
- INV-001: Order total must match sum of item totals
```

## AST validation goals

- Referential integrity across relationships
- Enum value uniqueness
- Invariant expressiveness check (detect vague rules)
- Every entity referenced by a relationship is declared

## Origin

Defined in issue #97 (Specification-First Development grammar suite, umbrella issue #93). Based on the Specification-First Development analysis reports.
