# Chef Recipe

Grammar for Chef recipes (Ruby DSL subset): resources with actions and properties, attributes, variables, notifiers and guard clauses.

## Syntax sketch

```
package 'nginx' do
  action :install
end
```

## AST validation goals

- Resource name uniqueness per type
- Attribute validity per resource type
- notifies/subscribes target existence
- Action validity for resource type
- Template source existence in cookbook

Implements issue #41.
