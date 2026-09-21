# Test Specification (.test) grammar

Grammar for the SpecTree `.test` test specification format. Each `.test` file binds to a target component (`.ai` spec or generated source file) and declares Given/When/Then scenarios, edge cases, coverage rules and performance thresholds.

## File extension

`.test`

## Syntax

```
# Test: OrderService
## Target: OrderService.cs
## Coverage: 100% requirement-coverage, must-level
### Test Scenarios
- Given a valid customer When creating an order Then order is created
- Should reject order with invalid items
### Performance Tests
- Should handle 100 concurrent order creations under 500ms
```

## AST validation goals

- Every functional requirement ID in the target .ai file covered by at least one scenario
- Scenarios reference valid component APIs
- Performance thresholds numeric and bounded
- must-level coverage for Must requirements

## Origin

Defined in issue #95 (Specification-First Development grammar suite, umbrella issue #93). Based on the Specification-First Development analysis reports.
