module OrderedSet exposing
    ( OrderedSet
    , empty, singleton, insert, remove
    , isEmpty, member, size
    , toList, fromList, toSet
    , map, foldl, foldr, filter, partition
    )

{-| A set of unique values that remembers their insertion order.
The values can be any comparable type. This includes `Int`,
`Float`, `Time`, `Char`, `String`, and tuples or lists
of comparable types.

The insertion order is reflected in the functions under
["Conversions"](#conversions) and ["Transform"](#transform).
The list order and the iteration order will be the order of insertion.

The API mirrors the core
[`Set`](https://package.elm-lang.org/packages/elm/core/latest/Set)'s
API, with exception for the functions listed there under
["Combine"](https://package.elm-lang.org/packages/elm/core/latest/Set#combine),
because these functions do not have an obvious way to handle
the order between the combined sets.


# Sets

@docs OrderedSet


# Build

@docs empty, singleton, insert, remove


# Query

@docs isEmpty, member, size


# Conversions

@docs toList, fromList, toSet


# Transform

@docs map, foldl, foldr, filter, partition

-}

import List
import Set exposing (Set)


{-| Represents a set of unique values that remembers insertion order.
-}
type OrderedSet comparable
    = OrderedSet
        { order : List comparable
        , set : Set comparable
        }


{-| Create an empty set.
-}
empty : OrderedSet comparable
empty =
    OrderedSet { order = [], set = Set.empty }


{-| Create a set with one value.
-}
singleton : comparable -> OrderedSet comparable
singleton key =
    OrderedSet
        { order = [ key ]
        , set = Set.singleton key
        }


{-| Insert a value into a set. If the key already exists,
the old value will be forgotten and the new value will be inserted at the end.

    import OrderedSet

    OrderedSet.empty
        |> OrderedSet.insert 1
        |> OrderedSet.insert 2
        |> OrderedSet.insert 1
        |> OrderedSet.toList
    --> [ 2, 1 ]

-}
insert : comparable -> OrderedSet comparable -> OrderedSet comparable
insert key (OrderedSet orderedSet) =
    if Set.member key orderedSet.set then
        OrderedSet
            { order = List.filter (\k -> k /= key) orderedSet.order ++ [ key ]
            , set = orderedSet.set
            }

    else
        OrderedSet
            { order = orderedSet.order ++ [ key ]
            , set = Set.insert key orderedSet.set
            }


{-| Remove a value from a set. If the value is not found,
no changes are made.
-}
remove : comparable -> OrderedSet comparable -> OrderedSet comparable
remove key ((OrderedSet orderedSet) as original) =
    if Set.member key orderedSet.set then
        OrderedSet
            { order = List.filter (\k -> k /= key) orderedSet.order
            , set = Set.remove key orderedSet.set
            }

    else
        original



-- QUERY


{-| Determine if a set is empty.
-}
isEmpty : OrderedSet comparable -> Bool
isEmpty (OrderedSet orderedSet) =
    Set.isEmpty orderedSet.set


{-| Determine if a value is in a set.
-}
member : comparable -> OrderedSet comparable -> Bool
member key (OrderedSet orderedSet) =
    Set.member key orderedSet.set


{-| Determine the number of elements in a set.
-}
size : OrderedSet comparable -> Int
size (OrderedSet orderedSet) =
    Set.size orderedSet.set



-- CONVERSIONS


{-| Convert a set into a list in insertion order.
-}
toList : OrderedSet comparable -> List comparable
toList (OrderedSet orderedSet) =
    orderedSet.order


{-| Convert a list into a set, removing any duplicates.
-}
fromList : List comparable -> OrderedSet comparable
fromList list =
    List.foldl insert empty list


{-| Convert an ordered set into a regular
[`Set`](https://package.elm-lang.org/packages/elm/core/latest/Set#Set).
-}
toSet : OrderedSet comparable -> Set comparable
toSet (OrderedSet orderedSet) =
    orderedSet.set



-- TRANSFORM


{-| Map a function onto a set, creating a new set with no duplicates.
-}
map : (comparable -> comparable2) -> OrderedSet comparable -> OrderedSet comparable2
map func (OrderedSet orderedSet) =
    List.map func orderedSet.order
        |> fromList


{-| Fold over the values in a set, in insertion order.
-}
foldl : (comparable -> b -> b) -> b -> OrderedSet comparable -> b
foldl func acc (OrderedSet orderedSet) =
    List.foldl func acc orderedSet.order


{-| Fold over the values in a set, in reverse insertion order.
-}
foldr : (comparable -> b -> b) -> b -> OrderedSet comparable -> b
foldr func acc (OrderedSet orderedSet) =
    List.foldr func acc orderedSet.order


{-| Only keep elements that pass the given test.
-}
filter :
    (comparable -> Bool)
    -> OrderedSet comparable
    -> OrderedSet comparable
filter predicate original =
    toList original
        |> List.filter predicate
        |> fromList


{-| Create two new sets. The first contains all the elements
that passed the given test, and the second contains
all the elements that did not.

The order will be preserved in these new sets in the sense
that elements that are inserted after each other will
remain ordered after each other.

-}
partition :
    (comparable -> Bool)
    -> OrderedSet comparable
    -> ( OrderedSet comparable, OrderedSet comparable )
partition predicate (OrderedSet orderedSet) =
    List.partition predicate orderedSet.order
        |> Tuple.mapBoth fromList fromList
