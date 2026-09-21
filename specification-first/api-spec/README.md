# Interface Specification (.api) grammar

Grammar for the SpecTree `.api` interface specification format. Declares versioned REST contracts: endpoints, request/response schemas with validation constraints, and mandatory error contracts.

## File extension

`.api`

## Syntax

```
# Interface: OrdersApi
## Version: 1.0
## Authentication: bearer
## BaseRoute: /api
### Endpoints
- POST /orders: Creates a new order => 201: OrderResponse
### Schemas
- OrderRequest: CustomerId: Guid required; Items: OrderItem[] required min=1
### ErrorContracts
- 400: Invalid order payload code=ORDER_INVALID
```

## AST validation goals

- Route uniqueness and parameter consistency
- Error contract completeness (every endpoint defines failure modes)
- Schema type compatibility with the .model grammar
- Deprecated endpoints not referenced by active specs

## Origin

Defined in issue #96 (Specification-First Development grammar suite, umbrella issue #93). Based on the Specification-First Development analysis reports.
