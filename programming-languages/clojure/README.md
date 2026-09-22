# Clojure

Minotaur grammar for Clojure, covering the core language subset.

## Syntax sketch

```
(defn square [x] (* x x))

(def users
  [{:name "Ada" :age 36}
   {:name "Alan" :age 41}])

(map :name users)
```

## AST validation goals

- balanced delimiters across lists, vectors, maps, sets
- defn forms have a symbol and argument vector
- maps have an even number of forms

Implements issue #72.

## Coverage completion

The grammar now also covers the remaining core language constructs:

- Atoms with `swap!`/`reset!`, dereferencing (`@`, `deref`)
- `defrecord` / `deftype` with protocols
- Rich `ns` clauses (`:require`, `:import`, `:refer`)
- Var quote (`#'var`) and syntax quote
