# PlantUML

Minotaur grammar for PlantUML, covering the core language subset.

## Syntax sketch

```
@startuml
participant User
participant Server
User -> Server: GET /api
Server --> User: 200 OK
@enduml
```

## AST validation goals

- @startuml/@enduml are balanced
- arrow statements reference declared participants
- class braces are balanced

Implements issue #92.

## Extended coverage

Adds sequence alt/loop/opt blocks, activations, dividers, notes over, stereotypes, component and use-case elements, and activity/state extras.
