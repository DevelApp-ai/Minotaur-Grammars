# Markdown

Minotaur grammar for Markdown, covering the core language subset.

## Syntax sketch

```
# Title

Some **bold** and *italic* text with a [link](https://example.com).

- item one
- item two

```python
print('hi')
```
```

## AST validation goals

- fenced code blocks are closed
- tables have a delimiter row matching column count
- heading level decreases by at most one

Implements issue #88.
