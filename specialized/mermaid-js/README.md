# Mermaid.js Diagrams

Minotaur grammar for Mermaid.js Diagrams, covering the core language subset.

## Syntax sketch

```
flowchart TD
  A[Start] --> B{Ready?}
  B -- yes --> C[Run]
  B -- no --> A
```

## AST validation goals

- edge endpoints reference declared nodes
- diagram type declared first
- sequence arrows use valid arrow forms

Implements issue #91.
