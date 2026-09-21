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
