# Bitbucket Pipelines Configuration

Minotaur grammar for Bitbucket Pipelines Configuration, covering the core language subset.

## Syntax sketch

```
image: mcr.microsoft.com/dotnet/sdk:8.0
pipelines:
  default:
    - step:
        name: Build
        script: [ dotnet build ]
        caches: [ dotnet ]
```

## AST validation goals

- caches reference defined caches or built-ins
- services reference defined services
- every step has a script

Implements issue #50.

## Extended coverage

Adds parallel steps, clone options (depth/lfs), pipeline options (max-time), deployment stages, conditions, pipe steps, and manual triggers.
