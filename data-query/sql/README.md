# SQL

Minotaur grammar for SQL, covering the core language subset.

## Syntax sketch

```
SELECT u.name, COUNT(o.id) AS order_count
FROM users u
LEFT JOIN orders o ON o.user_id = u.id
WHERE u.active = 1
GROUP BY u.name
HAVING COUNT(o.id) > 2
ORDER BY order_count DESC;
```

## AST validation goals

- SELECT list columns exist in FROM/JOIN tables
- INSERT column count matches VALUES count
- GROUP BY columns appear in select or aggregates

Implements issue #77.

## Extended coverage

Adds CTEs (WITH), subqueries, UNION, CASE expressions, window functions, views, transactions, EXISTS/IN subqueries, and TRUNCATE.
