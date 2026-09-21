# Ansible Playbook

Grammar for Ansible playbooks: plays with hosts and roles, task lists with modules, variables, handlers and Jinja2 templated values.

## Syntax sketch

```
- hosts: webservers
  tasks:
    - name: t
      apt: name=nginx state=present
```

## AST validation goals

- Handler names referenced by notify exist
- Module name validity
- Jinja2 expression balance
- Role existence
- register/when variable references

Implements issue #38.
