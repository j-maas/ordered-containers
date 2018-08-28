# ordered-containers

[![build status](https://travis-ci.org/Y0hy0h/ordered-containers.svg?branch=master)](https://travis-ci.org/Y0hy0h/ordered-containers)
[![elm package](https://img.shields.io/elm-package/v/y0hy0h/ordered-containers.svg)](https://package.elm-lang.org/packages/y0hy0h/ordered-containers/latest/)

Ordered implementations of Elm's `Dict` and `Set` data structures.

The default implementations do not keep track of their item's ordering. `OrderedDict` or `OrderedSet`, however, will respect the insertion order when iterating over their items (using e. g. `map` or `fold`), or converting them to a `List`.

---

This project is based on [rnon's `ordered-containers`](https://github.com/rnons/ordered-containers).
