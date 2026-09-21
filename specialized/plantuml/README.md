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

## Coverage completion

The grammar now also covers the remaining diagram types:

- Activity, deployment, object, and timing diagrams
