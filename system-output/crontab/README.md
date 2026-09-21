# Crontab

Minotaur grammar for Crontab, covering the core language subset.

## Syntax sketch

```
# nightly backup
30 2 * * * /usr/local/bin/backup.sh
0 */4 * * 1-5 /usr/bin/curl -s https://example.com/health
```

## AST validation goals

- five time fields before the command
- field ranges are within bounds (minute 0-59, hour 0-23, dom 1-31, month 1-12, dow 0-7)
- step values are positive

Implements issue #85.
