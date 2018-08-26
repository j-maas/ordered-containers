# ordered-containers

[![build status](https://travis-ci.org/Y0hy0h/ordered-containers.svg?branch=master)](https://travis-ci.org/Y0hy0h/ordered-containers)

Ordered implementations to Elm's `Dict` and `Set` data structures.

The default implementations do not keep track of their item's ordering. `OrderedDict` or `OrderedSet`, however, will respect the insertion order when iterating over their items (using e. g. `map` or `fold`), or converting them to a `List`.
