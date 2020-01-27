# ordered-containers

[![build status](https://github.com/y0hy0h/ordered-containers/workflows/Build/badge.svg)](https://github.com/Y0hy0h/ordered-containers/actions)
[![elm package](https://img.shields.io/elm-package/v/y0hy0h/ordered-containers.svg)](https://package.elm-lang.org/packages/y0hy0h/ordered-containers/latest/)

`OrderedDict` and `OrderedSet` that remember the order of insertion.

The default implementations do not keep track of their item's ordering. `OrderedDict` or `OrderedSet`, by contrast, will respect the insertion order when converting them to a `List` or iterating over their items (using `foldl`, `foldr`, or `partition`).

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
The API purposely includes all functions from the regular `Dict` and `Set` with the exception for the "Combine" functions (e.g., `union`, `diff`, etc.). Those are left out, because combining ordered collections is not obvious.

There also is an extra method for efficiently converting back to a regular collection, namely `OrderedDict.toDict` and `OrderedSet.toSet`.