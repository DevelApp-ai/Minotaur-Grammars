# BIND9 Zone File

Minotaur grammar for BIND9 Zone File, covering the core language subset.

## Syntax sketch

```
@ IN SOA ns1.example.com. admin.example.com. (
  2026010101 3600 900 1209600 3600 )
www 3600 IN A 192.0.2.10
```

## AST validation goals

- exactly one SOA record at zone apex
- MX records have a preference before the domain
- SOA serial is monotonically increasing across edits

Implements issue #55.
