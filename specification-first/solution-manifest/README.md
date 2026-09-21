# Solution Manifest (SpecTree binding to .NET) grammar

Grammar for the SpecTree **solution manifest** that binds the specification tree to a .NET solution: which `.csproj` each spec belongs to, target frameworks, which generator handles which spec type, and exclusion rules protecting hand-written code zones from regeneration.

## File extension

`.spectree (manifest)`

## Syntax

```
Solution: OrderPlatform
Project: DevelApp.Orders -> src/DevelApp.Orders/DevelApp.Orders.csproj tfm: net8.0
Spec: specifications/orders/order-service.ai -> DevelApp.Orders
Generate: CSharpGenerator for ai -> src/DevelApp.Orders/Generated
Exclude: src/DevelApp.Orders/Mappers/CustomMapper.cs reason: hand-optimized
```

## AST validation goals

- Every .ai spec belongs to exactly one project
- No circular project dependencies introduced by spec dependencies
- Orphan projects (no specs) flagged
- Excluded files not also generation targets

## Origin

Defined in issue #100 (Specification-First Development grammar suite, umbrella issue #93). Based on the Specification-First Development analysis reports.
