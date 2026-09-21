# LaTeX

Minotaur grammar for LaTeX, covering the core language subset.

## Syntax sketch

```
\documentclass{article}
\usepackage{amsmath}
\begin{document}
\section{Intro}
Hello $x^2 + y^2$.
\end{document}
```

## AST validation goals

- begin/end environments are balanced and named identically
- exactly one document environment
- math delimiters are paired

Implements issue #90.

## Extended coverage

Adds starred/heading commands, tabular with column specs, figures with includegraphics, labels and references, verbatim, bibliography, and theorem environments.
