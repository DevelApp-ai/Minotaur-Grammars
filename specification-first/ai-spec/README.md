# AI Component Specification (.ai) grammar

Grammar for the SpecTree `.ai` component specification format. Each `.ai` file declares one component: its name, namespace mapping to a .NET project, dependencies on other components, functional requirements with stable IDs, API endpoints, data-model references, and ADR compliance.

## File extension

`.ai`

## Syntax

```
# Component: OrderService
## Namespace: DevelApp.Orders
## Dependencies: PaymentService, InventoryService
### Requirements
- REQ-001: Must validate inventory before confirmation
### API Endpoints
- POST /api/orders: Creates a new order
### Data Model
- Order
  - Status: Enum
### Compliance
- complies-with ADR-0004
```

## AST validation goals

- Dependency cycles across components
- Missing referenced components
- Ambiguous or untestable requirement statements
- Hierarchy consistency (child does not contradict parent)

## Origin

Defined in issue #94 (Specification-First Development grammar suite, umbrella issue #93). Based on the Specification-First Development analysis reports.
