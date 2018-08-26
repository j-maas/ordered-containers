# ordered-containers

[![build status](https://travis-ci.org/Y0hy0h/ordered-containers.svg?branch=master)](https://travis-ci.org/Y0hy0h/ordered-containers)

An Elm library that provides ordered implementations to Elm's `Dict` and `Set` data structures.

The difference of the ordered versions, `OrderedDict` and `OrderedSet`, is that they remember the their item's insertion order. When iterated over, or converted to a `List`, the order will be the same as the order they were inserted.
