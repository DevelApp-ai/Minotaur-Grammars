# Nomad HCL

Grammar for HashiCorp Nomad job files (HCL): job groups with tasks, resources, networks, services, constraints, templates and stanza blocks.

## Syntax sketch

```
job "name" { group "g" { task "t" { driver = "docker" } } }
```

## AST validation goals

- Task driver validity
- Port references in services exist in network block
- Resource values positive
- Template destination path validity
- Check type/path validity

Implements issue #43.

## Coverage completion

Completes coverage with affinity/spread/reschedule/migrate stanzas, network with dynamic ports, CSI volumes, parameterized dispatch jobs, system jobs, and consul/connect integration.
