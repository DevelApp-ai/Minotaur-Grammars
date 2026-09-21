# Unix ps Output

Minotaur grammar for Unix ps Output, covering the core language subset.

## Syntax sketch

```
  PID TTY           TIME CMD
 1234 ttys000    0:01.23 -zsh
 5678 ?           2:45.10 /usr/sbin/sshd
```

## AST validation goals

- PID is numeric and unique
- TIME uses mm:ss.cc or h:mm:ss format
- CMD is the remainder of the line

Implements issue #84.

## Extended coverage

Adds BSD-style STAT codes, %CPU/%MEM columns, RSS/VSZ sizes, bracketed kernel threads, and SysV column layout.
