# Envoy Proxy Configuration

Minotaur grammar for Envoy Proxy Configuration, covering the core language subset.

## Syntax sketch

```
static_resources:
  listeners:
  - name: http
    address: { socket_address: { address: 0.0.0.0, port_value: 80 } }
    filter_chains: [ { filters: [ ] } ]
  clusters: [ ]
```

## AST validation goals

- listener filter names are known Envoy filters
- cluster load_assignment cluster_name matches cluster name
- port_value is in 0-65535

Implements issue #54.

## Coverage completion

Completes coverage with health checks, listener filters, overload manager, dynamic resources (ADS), retry policies, and outlier detection.
