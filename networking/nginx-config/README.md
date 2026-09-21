# Nginx Configuration

Minotaur grammar for Nginx Configuration, covering the core language subset.

## Syntax sketch

```
http {
  server {
    listen 80;
    location /api {
      proxy_pass http://backend;
    }
  }
}
```

## AST validation goals

- http block contains only server/upstream/location contexts
- every simple directive ends with ;
- listen directives have a port argument

Implements issue #51.
