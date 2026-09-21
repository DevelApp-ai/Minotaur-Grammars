# GitHub Actions Workflow

Minotaur grammar for GitHub Actions Workflow, covering the core language subset.

## Syntax sketch

```
name: CI
on:
  push:
    branches: [ main ]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: dotnet build
```

## AST validation goals

- Workflow references only defined jobs in needs
- Every step is either uses or run
- Matrix strategy references declared variables

Implements issue #46.

## Extended coverage

Adds concurrency, permissions, environment, timeout-minutes, continue-on-error, service containers, and reusable workflow_call triggers.
