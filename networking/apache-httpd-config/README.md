# Apache HTTP Server Configuration

Minotaur grammar for Apache HTTP Server Configuration, covering the core language subset.

## Syntax sketch

```
<VirtualHost *:80>
  ServerName example.com
  DocumentRoot /var/www/html
  <Directory /var/www/html>
    Require all granted
  </Directory>
</VirtualHost>
```

## AST validation goals

- every section open tag has a matching close tag
- VirtualHost sections declare a listen address
- directive names are known Apache directives

Implements issue #52.
