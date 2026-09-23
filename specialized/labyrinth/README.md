# Labyrinth

Grammar for the **Labyrinth** rule language — the specialized YAML format used by the Minotaur SAST rule engine to author security rules against arbitrary DevelApp custom grammars (via the CognitiveGraph). Rules guide security researchers through the labyrinth of code.

Implements issue #182. Engine implementation plan: DevelApp-ai/Minotaur#100. Strategic architecture report: DevelApp-ai/Minotaur#99.

## Syntax sketch

```yaml
rules:
  - id: custom-grammar-injection
    severity: ERROR
    message: "Untrusted data flows into a critical execution sink."
    type: taint
    sources:
      - pattern: "ReceiveData($DATA)"
    sinks:
      - pattern: "ExecuteAction(..., $DATA, ...)"
    sanitizers:
      - pattern: "VerifyIntegrity($DATA)"
    propagators:
      - pattern: "$TARGET = FormatString($SRC)"
        from: $SRC
        to: $TARGET
```

## Key constructs

- **Metavariables** (`$DATA`, `$TARGET`, ...): capture groups unifying AST nodes across a rule
- **Ellipsis** (`...`): matches zero or more arguments/statements/characters
- **Taint mode**: `sources`, `sinks`, `sanitizers`, `propagators` (with `from`/`to` bindings); the engine compiles patterns to Expression Tree delegates and runs a fixed-point taint traversal — rule authors never write graph queries
- **Dynamic LINQ escape hatch**: optional `condition` with a string-based C# boolean expression (System.Linq.Dynamic.Core), e.g. `node.Arguments[0].Value > 1024`

## AST validation goals

- Rule id uniqueness and severity/type validity
- Propagators referencing defined metavariables in their pattern
- Taint rules having at least one source and one sink
- Metavariable consistency across sources/sinks/sanitizers

## Coverage completion

Completes coverage with metadata blocks, language/path filters (include/exclude globs), fix suggestions, pattern-either / pattern-inside / pattern-not variants, and focus-metavariable selection.
