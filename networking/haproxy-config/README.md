# HAProxy Configuration

Minotaur grammar for HAProxy Configuration, covering the core language subset.

## Syntax sketch

```
defaults
  mode http
frontend web
  bind *:80
  default_backend app
backend app
  server s1 127.0.0.1:8080
```

## AST validation goals

- default_backend references a declared backend
- frontend sections declare a bind
- backend servers use valid address:port

Implements issue #53.
