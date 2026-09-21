# GitLab CI Pipeline

Minotaur grammar for GitLab CI Pipeline, covering the core language subset.

## Syntax sketch

```
stages: [build, test]
build-job:
  stage: build
  script:
    - dotnet build
test-job:
  stage: test
  rules:
    - if: '$CI_COMMIT_BRANCH == "main"'
```

## AST validation goals

- Every job stage exists in the stages list
- extends targets defined (hidden) jobs
- rules use valid when values

Implements issue #47.
