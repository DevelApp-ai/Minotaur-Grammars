# Makefile

Grammar for GNU Makefiles: rules with targets and prerequisites, recipes with tab indentation, variables, pattern rules, conditionals, include and .PHONY declarations.

## Syntax sketch

```
target: prereq
	command
```

## AST validation goals

- Target/prerequisite existence
- Recipe lines must start with tab
- Conditional nesting balance (ifeq/endif)
- Undefined variable references
- .PHONY targets declared
- Pattern rule stem consistency

Implements issue #45.

## Coverage completion

Completes coverage with := and != assignment operators, override/undefine, .DEFAULT_GOAL, environment overrides, order-only prerequisites, secondary expansion, and per-target variables.
