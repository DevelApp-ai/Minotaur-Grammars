# Jenkinsfile (Declarative Pipeline)

Minotaur grammar for Jenkinsfile (Declarative Pipeline), covering the core language subset.

## Syntax sketch

```
pipeline {
  agent any
  stages {
    stage('Build') {
      steps { sh 'dotnet build' }
    }
  }
  post { always { echo 'done' } }
}
```

## AST validation goals

- Pipeline has exactly one agent and stages block
- post conditions use valid condition names
- stage names are unique

Implements issue #48.
