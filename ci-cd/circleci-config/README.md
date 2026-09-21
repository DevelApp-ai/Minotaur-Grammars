# CircleCI Configuration

Minotaur grammar for CircleCI Configuration, covering the core language subset.

## Syntax sketch

```
version: 2.1
jobs:
  build:
    docker: [ image: cimg/base:stable ]
    steps: [ checkout, run: dotnet build ]
workflows:
  main:
    jobs: [ build ]
```

## AST validation goals

- workflow jobs reference defined jobs
- requires lists reference jobs in the same workflow
- version is present and numeric

Implements issue #49.

## Extended coverage

Adds matrix configs, contexts, workspace persistence/attachment, artifact and test-result storage, and tag filters.
