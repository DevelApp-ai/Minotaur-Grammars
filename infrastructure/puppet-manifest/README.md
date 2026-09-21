# Puppet Manifest

Grammar for Puppet manifests: class and defined-type declarations, resource declarations with attributes, variables, node definitions and expressions.

## Syntax sketch

```
package { 'nginx': ensure => installed }
```

## AST validation goals

- Resource title uniqueness per type
- Attribute validity per resource type
- require/notify/before reference resolution
- Class name resolution
- Variable defined before use

Implements issue #40.
