module OrderedDict exposing
    ( OrderedDict
    , empty, singleton, insert, update, remove
    , isEmpty, member, get, size
    , keys, values, toList, fromList
    , map, foldl, foldr, filter, partition
    , union, intersect, diff
    )

{-| A dictionary type that when iterated or converted to a list, the order of
entries will be the same as the order they were inserted.

As it uses `Dict` under the hood, the keys can only be comparable types, which
include `Int`, `Float`, `Time`, `Char`, `String`, and tuples or lists of
comparable types.


# Dictionaries

@docs OrderedDict


# Build

@docs empty, singleton, insert, update, remove


# Query

@docs isEmpty, member, get, size


# Lists

@docs keys, values, toList, fromList


# Transform

@docs map, foldl, foldr, filter, partition


# Combine

@docs union, intersect, diff

-}

import Dict exposing (Dict)
import List


{-| A type of `Dict` that is iterated by the order of insertion.
-}
type OrderedDict comparable v
    = OrderedDict (List comparable) (Dict comparable v)


{-| Create an empty dictionary.
-}
empty : OrderedDict comparable v
empty =
    OrderedDict [] Dict.empty


{-| Check if a dictionary is empty.
-}
isEmpty : OrderedDict comparable v -> Bool
isEmpty odict =
    odict == empty


{-| Get the value associated with a key. Return `Nothing` if the key is not found.
-}
get : comparable -> OrderedDict comparable v -> Maybe v
get key (OrderedDict _ dict) =
    Dict.get key dict


{-| Check if a key is in a dictionary.
-}
member : comparable -> OrderedDict comparable v -> Bool
member key (OrderedDict _ dict) =
    Dict.member key dict


{-| Get the number of key-value pairs in the dictionary.
-}
size : OrderedDict comparable v -> Int
size (OrderedDict list _) =
    List.length list


{-| Create a dictionary with one key-value pair.
-}
singleton : comparable -> v -> OrderedDict comparable v
singleton key value =
    insert key value empty


{-| Insert a key-value pair into a dictionary. Replace the value if the key
already exists.
-}
insert : comparable -> v -> OrderedDict comparable v -> OrderedDict comparable v
insert key value odict =
    update key (always (Just value)) odict


{-| Remove a key-value pair from a dictionary. If the key doesn't exist,
no changes are made.
-}
remove : comparable -> OrderedDict comparable v -> OrderedDict comparable v
remove key odict =
    update key (always Nothing) odict


{-| Update the value of a specific key with an updater function.

Since the key may not exist before or after the update, the updater function
takes a `Maybe v` and returns a `Maybe v`.

-}
update :
    comparable
    -> (Maybe v -> Maybe v)
    -> OrderedDict comparable v
    -> OrderedDict comparable v
update key updater (OrderedDict list dict) =
    let
        newDict =
            Dict.update key updater dict

        newList =
            case updater (Dict.get key dict) of
                Just _ ->
                    if List.member key list then
                        list

                    else
                        list ++ [ key ]

                Nothing ->
                    if List.member key list then
                        List.filter (\k -> k /= key) list

                    else
                        list
    in
    OrderedDict newList newDict



-- TRANSFORM


{-| Apply a function to all values in a dictionary.
-}
map : (comparable -> a -> b) -> OrderedDict comparable a -> OrderedDict comparable b
map f (OrderedDict list dict) =
    OrderedDict list (Dict.map f dict)


reducer :
    Dict comparable v
    -> (comparable -> v -> b -> b)
    -> (comparable -> b -> b)
reducer dict f =
    \key acc ->
        case Dict.get key dict of
            Just value ->
                f key value acc

            Nothing ->
                acc


{-| Fold the key-value pairs in a dictionary, in insertion order.
-}
foldl : (comparable -> v -> b -> b) -> b -> OrderedDict comparable v -> b
foldl f acc (OrderedDict list dict) =
    List.foldl (reducer dict f) acc list


{-| Fold the key-value pairs in a dictionary, in reverse insertion order.
-}
foldr : (comparable -> v -> b -> b) -> b -> OrderedDict comparable v -> b
foldr f acc (OrderedDict list dict) =
    List.foldr (reducer dict f) acc list


{-| Return a new `OrderedDict` that only contains entries that satisfy a predicate.
-}
filter :
    (comparable -> v -> Bool)
    -> OrderedDict comparable v
    -> OrderedDict comparable v
filter predicate dictionary =
    let
        add key value odict =
            if predicate key value then
                insert key value odict

            else
                odict
    in
    foldl add empty dictionary


{-| Split a `OrderedDict` to a tuple of `OrderedDict`. The first contains all
entries that satisfy the predicate, and the second contains the rest.
-}
partition :
    (comparable -> v -> Bool)
    -> OrderedDict comparable v
    -> ( OrderedDict comparable v, OrderedDict comparable v )
partition predicate dictionary =
    let
        add key value ( odict1, odict2 ) =
            if predicate key value then
                ( insert key value odict1, odict2 )

            else
                ( odict1, insert key value odict2 )
    in
    foldl add ( empty, empty ) dictionary



-- LISTS


{-| Get all of the keys in a dictionary, in insertion order.
-}
keys : OrderedDict comparable v -> List comparable
keys (OrderedDict list _) =
    list


{-| Get all of the values in a dictionary, in insertion order.
-}
values : OrderedDict comparable v -> List v
values (OrderedDict list dict) =
    List.filterMap (\key -> Dict.get key dict) list


{-| Convert a dictionary into an association list of key-value pairs, in insertion order.
-}
toList : OrderedDict comparable v -> List ( comparable, v )
toList (OrderedDict list dict) =
    List.map2 (\a b -> ( a, b )) list (values <| OrderedDict list dict)


{-| Convert an association list into a dictionary.
-}
fromList : List ( comparable, v ) -> OrderedDict comparable v
fromList assocs =
    let
        ( list, _ ) =
            List.unzip assocs

        dict =
            Dict.fromList assocs
    in
    OrderedDict list dict



-- COMBINE


{-| Combine two dictionaries. If there is a collision, preference is given
to the first dictionary.

    union (singleton "x" 1) (singleton "x" 2) == singleton "x" 1

-}
union : OrderedDict comparable v -> OrderedDict comparable v -> OrderedDict comparable v
union odict1 odict2 =
    let
        unionReducer =
            \k v acc ->
                if member k odict1 then
                    acc

                else
                    insert k v acc
    in
    foldl unionReducer odict1 odict2


{-| Keep a key-value pair when its key appears in the second dictionary.
Preference is given to values in the first dictionary.
-}
intersect :
    OrderedDict comparable v
    -> OrderedDict comparable v
    -> OrderedDict comparable v
intersect odict1 odict2 =
    filter (\k _ -> member k odict2) odict1


{-| Keep a key-value pair when its key does not appear in the second dictionary.
-}
diff : OrderedDict comparable v -> OrderedDict comparable v -> OrderedDict comparable v
diff odict1 odict2 =
    foldl (\k v t -> remove k t) odict1 odict2
