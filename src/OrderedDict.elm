module OrderedDict exposing
    ( OrderedDict
    , empty, singleton, insert, update, remove
    , isEmpty, member, get, size
    , keys, values, toList, fromList, toDict
    , map, foldl, foldr, filter, partition
    )

{-| A dictionary mapping unique keys to values while remembering their
insertion order. The keys can be any comparable type. This includes
`Int`, `Float`, `Time`, `Char`, `String`, and tuples or lists
of comparable types.

The insertion order is reflected in the functions under
["Conversions"](#conversions) and ["Transform"](#transform).
The order in the lists and the iteration order will be the order of insertion.

The API mirrors the core
[`Dict`](https://package.elm-lang.org/packages/elm/core/latest/Dict)'s
API, with exception for the functions listed there under
["Combine"](https://package.elm-lang.org/packages/elm/core/latest/Dict#combine),
because these functions do not have an obvious way to handle
the order between the combined dictionaries.


# Dictionaries

@docs OrderedDict


# Build

@docs empty, singleton, insert, update, remove


# Query

@docs isEmpty, member, get, size


# Conversions

@docs keys, values, toList, fromList, toDict


# Transform

@docs map, foldl, foldr, filter, partition

-}

import Dict exposing (Dict)
import List


{-| A dictionary of keys and values that remembers the order of insertion.
-}
type OrderedDict comparable v
    = OrderedDict
        { order : List comparable
        , dict : Dict comparable v
        }


{-| Create an empty dictionary.
-}
empty : OrderedDict comparable v
empty =
    OrderedDict { order = [], dict = Dict.empty }


{-| Create a dictionary with one key-value pair.
-}
singleton : comparable -> v -> OrderedDict comparable v
singleton key value =
    OrderedDict
        { order = [ key ]
        , dict = Dict.singleton key value
        }


{-| Insert a key-value pair into a dictionary. If the key already exists,
the old value will be forgotten and the new value will be inserted at the end.

    import OrderedDict

    OrderedDict.empty
        |> OrderedDict.insert 1 "one"
        |> OrderedDict.insert 2 "two"
        |> OrderedDict.insert 1 "three"
        |> OrderedDict.toList
    --> [ (2, "two"), (1, "three") ]

-}
insert : comparable -> v -> OrderedDict comparable v -> OrderedDict comparable v
insert key value (OrderedDict orderedDict) =
    let
        filteredOrder =
            if Dict.member key orderedDict.dict then
                List.filter (\k -> k /= key) orderedDict.order

            else
                orderedDict.order

        newOrder =
            filteredOrder ++ [ key ]
    in
    OrderedDict
        { order = newOrder
        , dict = Dict.insert key value orderedDict.dict
        }


{-| Remove a key-value pair from a dictionary. If the key is not found,
no changes are made.
-}
remove : comparable -> OrderedDict comparable v -> OrderedDict comparable v
remove key (OrderedDict orderedDict) =
    OrderedDict
        { order =
            if Dict.member key orderedDict.dict then
                List.filter (\k -> k /= key) orderedDict.order

            else
                orderedDict.order
        , dict = Dict.remove key orderedDict.dict
        }


{-| Update the value of a dictionary for a specific key with a given function.

If a value exists for the key and the passed function returns a `Just v`,
the value will be replaced, keeping its order. If it did not exist, the
new value will be added to the end.

When the function returns a `Nothing`, the key is removed.

    import OrderedDict

    OrderedDict.empty
        |> OrderedDict.insert 1 "one"
        |> OrderedDict.insert 2 "two"
        |> OrderedDict.update 1 (\_ -> Just "three")
        |> OrderedDict.toList
    --> [ (1, "three"), (2, "two") ]

    OrderedDict.singleton 1 "one"
        |> OrderedDict.update 2 (\_ -> Just "two")
        |> OrderedDict.toList
    --> [ (1, "one"), (2, "two") ]

    OrderedDict.singleton 1 "one"
        |> OrderedDict.update 1 (\_ -> Nothing)
        |> OrderedDict.toList
    --> []

-}
update :
    comparable
    -> (Maybe v -> Maybe v)
    -> OrderedDict comparable v
    -> OrderedDict comparable v
update key alter ((OrderedDict orderedDict) as original) =
    case Dict.get key orderedDict.dict of
        Just oldItem ->
            case alter (Just oldItem) of
                Just newItem ->
                    OrderedDict
                        { order = orderedDict.order
                        , dict = Dict.update key (always (Just newItem)) orderedDict.dict
                        }

                Nothing ->
                    remove key original

        Nothing ->
            case alter Nothing of
                Just newItem ->
                    insert key newItem original

                Nothing ->
                    original



-- QUERY


{-| Determine if a dictionary is empty.
-}
isEmpty : OrderedDict comparable v -> Bool
isEmpty (OrderedDict orderedDict) =
    Dict.isEmpty orderedDict.dict


{-| Determine if a key is in a dictionary.
-}
member : comparable -> OrderedDict comparable v -> Bool
member key (OrderedDict orderedDict) =
    Dict.member key orderedDict.dict


{-| Get the value associated with a key. If the key is not found, return Nothing.
-}
get : comparable -> OrderedDict comparable v -> Maybe v
get key (OrderedDict orderedDict) =
    Dict.get key orderedDict.dict


{-| Determine the number of key-value pairs in the dictionary.
-}
size : OrderedDict comparable v -> Int
size (OrderedDict orderedDict) =
    Dict.size orderedDict.dict



-- CONVERSIONS


{-| Get all of the keys in a dictionary, in insertion order.
-}
keys : OrderedDict comparable v -> List comparable
keys (OrderedDict orderedDict) =
    orderedDict.order


{-| Get all of the values in a dictionary, in insertion order.
-}
values : OrderedDict comparable v -> List v
values (OrderedDict orderedDict) =
    List.filterMap (\key -> Dict.get key orderedDict.dict) orderedDict.order


{-| Convert a dictionary into an association list of key-value pairs, in insertion order.
-}
toList : OrderedDict comparable v -> List ( comparable, v )
toList (OrderedDict orderedDict) =
    List.filterMap
        (\key ->
            Dict.get key orderedDict.dict
                |> Maybe.map (\value -> ( key, value ))
        )
        orderedDict.order


{-| Convert an association list into a dictionary.

If a key appears multiple times in the list, only the last occurrence is kept.

-}
fromList : List ( comparable, v ) -> OrderedDict comparable v
fromList assocs =
    List.foldl (\( key, value ) dict -> insert key value dict) empty assocs


{-| Convert an ordered dictionary into a regular
[`Dict`](https://package.elm-lang.org/packages/elm/core/latest/Dict#Dict).
-}
toDict : OrderedDict comparable v -> Dict comparable v
toDict (OrderedDict orderedDict) =
    orderedDict.dict



-- TRANSFORM


{-| Apply a function to all values in a dictionary.
-}
map : (comparable -> a -> b) -> OrderedDict comparable a -> OrderedDict comparable b
map func (OrderedDict orderedDict) =
    OrderedDict { order = orderedDict.order, dict = Dict.map func orderedDict.dict }


{-| Fold over the key-value pairs in a dictionary in insertion order.
-}
foldl : (comparable -> v -> b -> b) -> b -> OrderedDict comparable v -> b
foldl func acc (OrderedDict orderedDict) =
    List.foldl (reducer orderedDict.dict func) acc orderedDict.order


{-| Fold over the key-value pairs in a dictionary in reverse insertion order.
-}
foldr : (comparable -> v -> b -> b) -> b -> OrderedDict comparable v -> b
foldr func acc (OrderedDict orderedDict) =
    List.foldr (reducer orderedDict.dict func) acc orderedDict.order


reducer :
    Dict comparable v
    -> (comparable -> v -> b -> b)
    -> (comparable -> b -> b)
reducer dict func =
    \key acc ->
        case Dict.get key dict of
            Just value ->
                func key value acc

            Nothing ->
                acc


{-| Keep only the key-value pairs that pass the given test.
-}
filter :
    (comparable -> v -> Bool)
    -> OrderedDict comparable v
    -> OrderedDict comparable v
filter predicate original =
    toList original
        |> List.filter (\( k, v ) -> predicate k v)
        |> fromList


{-| Partition a dictionary according to some test. The first dictionary
contains all key-value pairs which passed the test, and the second
contains the pairs that did not.

The order will be preserved in these new dictionaries in the sense
that elements that are inserted after each other will
remain ordered after each other.

-}
partition :
    (comparable -> v -> Bool)
    -> OrderedDict comparable v
    -> ( OrderedDict comparable v, OrderedDict comparable v )
partition predicate original =
    toList original
        |> List.partition (\( k, v ) -> predicate k v)
        |> Tuple.mapBoth fromList fromList
