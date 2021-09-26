# ordered-containers

[![build status](https://github.com/y0hy0h/ordered-containers/workflows/Build/badge.svg)](https://github.com/Y0hy0h/ordered-containers/actions)
[![elm package](https://img.shields.io/elm-package/v/y0hy0h/ordered-containers.svg)](https://package.elm-lang.org/packages/y0hy0h/ordered-containers/latest/)
[![Passively maintained](https://img.shields.io/badge/maintenance-passive-yellow)](#maintenance)

[`OrderedDict`] and [`OrderedSet`] that remember the order of insertion.

The default implementations, [`Dict`] and [`Set`], do not keep track of their item's ordering. [`OrderedDict`] or [`OrderedSet`], by contrast, will respect the insertion order when converting them to a [`List`] or iterating over their items (using [`foldl`][`OrderedDict.foldl`], [`foldr`][`OrderedDict.foldr`], or [`partition`][`OrderedDict.partition`]).

## Examples
```elm
import OrderedSet
import Set

-- Remembers insertion order
OrderedSet.empty
    |> OrderedSet.insert 2
    |> OrderedSet.insert 1
    |> OrderedSet.insert 3
    |> OrderedSet.toList
--> [ 2, 1, 3 ]

-- Orders by keys
Set.empty
    |> Set.insert 2
    |> Set.insert 1
    |> Set.insert 3
    |> Set.toList
--> [ 1, 2, 3 ]
```

```elm
import Dict
import OrderedDict

-- Remembers insertion order
OrderedDict.empty
    |> OrderedDict.insert 3 "first"
    |> OrderedDict.insert 1 "second"
    |> OrderedDict.insert 2 "third"
    |> OrderedDict.toList
--> [ ( 3, "first" ), ( 1, "second" ), ( 2, "third" ) ]

-- Orders by keys
Dict.empty
    |> Dict.insert 3 "first"
    |> Dict.insert 1 "second"
    |> Dict.insert 2 "third"
    |> Dict.toList
--> [ ( 1, "second" ), ( 2, "third" ), ( 3, "first") ]
```

## Comparison to `Dict` and `Set`
The API purposely includes all functions from the regular [`Dict`] and [`Set`] with the exception for the ["Combine"](https://package.elm-lang.org/packages/elm/core/latest/Dict#combine) functions (e.g., [`union`][`Dict.union`], [`diff`][`Dict.diff`], etc.). Those are left out, because combining ordered collections does not have a single obvious solution. You can always write custom combination functions for your use case!

In addition to the regular API there is a method for efficiently converting back to a regular collection, namely [`OrderedDict.toDict`] and [`OrderedSet.toSet`].

## How it works
The [`OrderedDict`], in addition to a plain [`Dict`], keeps a [`List`] of all the keys in the order they are inserted.

This means that we sacrifice some space, but get the performance of [`Dict`] for its ["Query"](https://package.elm-lang.org/packages/y0hy0h/ordered-containers/latest/OrderedDict#query) operations, while only introducing minor overhead to the rest.

As an alternative, [`pzp1997/assoc-list`](https://package.elm-lang.org/packages/pzp1997/assoc-list/latest/) stores only a list while providing a [`Dict`]-like interface.

## History and contributors
Originally, this package was based on [rnon's `ordered-containers`](https://github.com/rnons/ordered-containers) and updated for Elm 0.19. Later, it was merged with [wittjosiah's `elm-ordered-dict`](https://github.com/wittjosiah/elm-ordered-dict) and rewritten to handle re-insertion in a clearly documented way.

[`OrderedDict`]: https://package.elm-lang.org/packages/y0hy0h/ordered-containers/latest/OrderedDict
[`OrderedDict.foldl`]: https://package.elm-lang.org/packages/y0hy0h/ordered-containers/latest/OrderedDict#foldl
[`OrderedDict.foldr`]: https://package.elm-lang.org/packages/y0hy0h/ordered-containers/latest/OrderedDict#foldr
[`OrderedDict.partition`]: https://package.elm-lang.org/packages/y0hy0h/ordered-containers/latest/OrderedDict#partition
[`OrderedDict.toDict`]: https://package.elm-lang.org/packages/y0hy0h/ordered-containers/latest/OrderedDict#toDict
[`OrderedDict.toList`]: https://package.elm-lang.org/packages/y0hy0h/ordered-containers/latest/OrderedDict#toList

[`OrderedSet`]: https://package.elm-lang.org/packages/y0hy0h/ordered-containers/latest/OrderedSet
[`OrderedSet.toSet`]: https://package.elm-lang.org/packages/y0hy0h/ordered-containers/latest/OrderedSet#toSet

[`Dict`]: https://package.elm-lang.org/packages/elm/core/latest/Dict
[`Dict.union`]: https://package.elm-lang.org/packages/elm/core/latest/Dict#union
[`Dict.diff`]: https://package.elm-lang.org/packages/elm/core/latest/Dict#diff
[`Dict.map`]: https://package.elm-lang.org/packages/elm/core/latest/Dict#map
[`Set`]: https://package.elm-lang.org/packages/elm/core/latest/Set
[`List`]: https://package.elm-lang.org/packages/elm/core/latest/List

## Maintenance
This project is passively maintened. I intend to respond to issues and pull requests, but am not dedicating time to develop new features.
