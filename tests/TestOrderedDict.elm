module TestOrderedDict exposing (buildTests, combineTests, listTests, queryTests, transformTests, updateTests)

import Expect
import OrderedDict exposing (..)
import Test exposing (..)


buildTests : Test
buildTests =
    describe "build a dict"
        [ test "empty" <|
            \() -> Expect.equal empty (fromList [])
        , test "singleton" <|
            \() -> Expect.equal (singleton "x" 1) (fromList [ ( "x", 1 ) ])
        , test "insert" <|
            \() -> Expect.equal (insert "x" 1 empty) (fromList [ ( "x", 1 ) ])
        , test "remove not existing key" <|
            \() -> Expect.equal (remove "x" (singleton "y" 2)) (singleton "y" 2)
        , test "remove existing key" <|
            \() -> Expect.equal (remove "x" (singleton "x" 1)) empty
        ]


updateTests : Test
updateTests =
    describe "update"
        [ test "is not memeber and updater function returns Nothing" <|
            \() ->
                Expect.equal (update "x" (always Nothing) empty) empty
        , test "is not memeber and updater function returns Just" <|
            \() ->
                Expect.equal (update "x" (always (Just 1)) empty) (singleton "x" 1)
        , test "is member and updater function returns Nothing" <|
            \() ->
                Expect.equal (update "x" (always Nothing) (singleton "x" 1)) empty
        , test "is member and updater function returns Just" <|
            \() ->
                Expect.equal (update "x" (always (Just 2)) (singleton "x" 1))
                    (singleton "x" 2)
        ]


queryTests : Test
queryTests =
    describe "query tests"
        [ test "isEmpty True" <|
            \() -> Expect.equal (isEmpty empty) True
        , test "isEmpty False" <|
            \() -> Expect.equal (isEmpty (singleton "x" 1)) False
        , test "member True" <|
            \() -> Expect.equal (member "x" (singleton "x" 1)) True
        , test "member False" <|
            \() -> Expect.equal (member "y" (singleton "x" 1)) False
        , test "get Just value" <|
            \() -> Expect.equal (get "x" (singleton "x" 1)) (Just 1)
        , test "get Nothing" <|
            \() -> Expect.equal (get "y" (singleton "x" 1)) Nothing
        , test "size of empty" <|
            \() -> Expect.equal (size empty) 0
        , test "size" <|
            \() -> Expect.equal (size (fromList [ ( "x", 1 ), ( "y", 2 ) ])) 2
        ]


listTests : Test
listTests =
    let
        dict =
            fromList [ ( "y", 2 ), ( "x", 1 ) ]
    in
    describe "list tests"
        [ test "keys" <|
            \() -> Expect.equal (keys dict) [ "y", "x" ]
        , test "values" <|
            \() -> Expect.equal (values dict) [ 2, 1 ]
        , test "toList" <|
            \() -> Expect.equal (toList dict) [ ( "y", 2 ), ( "x", 1 ) ]
        ]


transformTests : Test
transformTests =
    let
        dict =
            fromList [ ( "y", 2 ), ( "x", 1 ) ]
    in
    describe "transform tests"
        [ test "map" <|
            \() ->
                Expect.equal (map (\k v -> ( k, v )) dict)
                    (fromList [ ( "y", ( "y", 2 ) ), ( "x", ( "x", 1 ) ) ])
        , test "filter" <|
            \() -> Expect.equal (filter (\k v -> v > 1) dict) (singleton "y" 2)
        , test "foldl" <|
            \() ->
                Expect.equal (foldl (\k v acc -> acc + v) 0 dict) 3
        , test "foldr" <|
            \() ->
                Expect.equal (foldr (\k v acc -> acc ++ k) "" dict) "xy"
        , test "partition" <|
            \() ->
                Expect.equal (partition (\k v -> v < 2) dict)
                    ( singleton "x" 1, singleton "y" 2 )
        ]


combineTests : Test
combineTests =
    let
        dict1 =
            fromList [ ( "y", 2 ), ( "x", 1 ) ]

        dict2 =
            fromList [ ( "y", 3 ), ( "z", 10 ) ]
    in
    describe "combine tests"
        [ test "union" <|
            \() ->
                Expect.equal (union dict1 dict2)
                    (fromList [ ( "y", 2 ), ( "x", 1 ), ( "z", 10 ) ])
        , test "intersect" <|
            \() ->
                Expect.equal (intersect dict1 dict2)
                    (fromList [ ( "y", 2 ) ])
        , test "diff" <|
            \() ->
                Expect.equal (diff dict1 dict2)
                    (fromList [ ( "x", 1 ) ])
        ]
