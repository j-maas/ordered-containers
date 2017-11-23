module OrderedSet
    exposing
        ( OrderedSet
        , empty
        , singleton
        , insert
        , remove
        , isEmpty
        , member
        , size
        , foldl
        , foldr
        , map
        , filter
        , partition
        , toList
        , fromList
        , union
        , intersect
        , diff
        )

{-| A set of unique values that when iterated or converted to a list, the order of
values will be the same as the order they were inserted.

As it uses `Dict` under the hood, the keys can only be comparable types, which
include `Int`, `Float`, `Time`, `Char`, `String`, and tuples or lists of
comparable types.


# Sets

@docs OrderedSet


# Build

@docs empty, singleton, insert, remove


# Query

@docs isEmpty, member, size


# Lists

@docs toList, fromList


# Transform

@docs map, foldl, foldr, filter, partition


# Combine

@docs union, intersect, diff

-}

import Dict exposing (Dict)
import List


{-| A type of `Set` that is iterated by the order of insertion.
-}
type OrderedSet comparable
    = OrderedSet (List comparable) (Dict comparable ())


{-| Create an empty set.
-}
empty : OrderedSet comparable
empty =
    OrderedSet [] Dict.empty


{-| Check if a set is empty.
-}
isEmpty : OrderedSet comparable -> Bool
isEmpty oset =
    oset == empty


{-| Check if a value is in a set.
-}
member : comparable -> OrderedSet comparable -> Bool
member key (OrderedSet _ dict) =
    Dict.member key dict


{-| Get the number of values in the set.
-}
size : OrderedSet comparable -> Int
size (OrderedSet list _) =
    List.length list


{-| Create a set with one value.
-}
singleton : comparable -> OrderedSet comparable
singleton key =
    insert key empty


{-| Insert a value into a set.
-}
insert : comparable -> OrderedSet comparable -> OrderedSet comparable
insert key (OrderedSet list dict) =
    case Dict.get key dict of
        Just _ ->
            OrderedSet list dict

        Nothing ->
            OrderedSet (list ++ [ key ]) (Dict.insert key () dict)


{-| Remove a value from a set. If the value doesn't exist,
no changes are made.
-}
remove : comparable -> OrderedSet comparable -> OrderedSet comparable
remove key (OrderedSet list dict) =
    case Dict.get key dict of
        Just _ ->
            OrderedSet (List.filter (\k -> k /= key) list) (Dict.remove key dict)

        Nothing ->
            OrderedSet list dict



-- TRANSFORM


{-| Apply a function to all values in a set.
-}
map : (comparable -> comparable2) -> OrderedSet comparable -> OrderedSet comparable2
map f (OrderedSet list _) =
    fromList <| List.map f list


{-| Fold the values in a set, in insertion order.
-}
foldl : (comparable -> b -> b) -> b -> OrderedSet comparable -> b
foldl f acc (OrderedSet list _) =
    List.foldl f acc list


{-| Fold the values in a set, in reverse insertion order.
-}
foldr : (comparable -> b -> b) -> b -> OrderedSet comparable -> b
foldr f acc (OrderedSet list _) =
    List.foldr f acc list


{-| Return a new `OrderedSet` that only contains values that satisfy a predicate.
-}
filter :
    (comparable -> Bool)
    -> OrderedSet comparable
    -> OrderedSet comparable
filter predicate (OrderedSet list dict) =
    OrderedSet (List.filter predicate list)
        (Dict.filter (\k _ -> predicate k) dict)


{-| Split a `OrderedSet` to a tuple of `OrderedSet`. The first contains all
values that satisfy the predicate, and the second contains the rest.
-}
partition :
    (comparable -> Bool)
    -> OrderedSet comparable
    -> ( OrderedSet comparable, OrderedSet comparable )
partition predicate (OrderedSet list dict) =
    let
        ( list1, list2 ) =
            List.partition predicate list

        ( dict1, dict2 ) =
            Dict.partition (\k _ -> predicate k) dict
    in
        ( OrderedSet list1 dict1, OrderedSet list2 dict2 )



-- LISTS


{-| Convert a set into a list, sorted by insertion order.
-}
toList : OrderedSet comparable -> List comparable
toList (OrderedSet list _) =
    list


{-| Convert a list into a set, removing any duplicates.
-}
fromList : List comparable -> OrderedSet comparable
fromList xs =
    List.foldl insert empty xs



-- COMBINE


{-| Combine two sets. Keep all values while removing any duplicates.
-}
union : OrderedSet comparable -> OrderedSet comparable -> OrderedSet comparable
union oset1 oset2 =
    let
        reducer =
            \k acc ->
                if member k oset1 then
                    acc
                else
                    insert k acc
    in
        foldl reducer oset1 oset2


{-| Combine two sets. Keep values that appear in both sets.
-}
intersect :
    OrderedSet comparable
    -> OrderedSet comparable
    -> OrderedSet comparable
intersect oset1 oset2 =
    filter (\k -> member k oset2) oset1


{-| Keep values of the first set that do not appear in the second set.
-}
diff : OrderedSet comparable -> OrderedSet comparable -> OrderedSet comparable
diff oset1 oset2 =
    foldl (\k t -> remove k t) oset1 oset2
