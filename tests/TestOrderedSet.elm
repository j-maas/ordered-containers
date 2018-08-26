module TestOrderedSet exposing (buildTests, combineTests, listTests, queryTests, transformTests)

import Expect
import OrderedSet exposing (..)
import Test exposing (..)


buildTests : Test
buildTests =
    describe "build a set"
        [ test "empty" <|
            \() ->
                Expect.equal empty (fromList [])
        , test "singleton" <|
            \() ->
                Expect.equal (singleton "x") (fromList [ "x" ])
        , test "insert to an empty set" <|
            \() ->
                Expect.equal (insert "x" empty) (singleton "x")
        , test "insert to a not empty set" <|
            \() ->
                Expect.equal (insert "x" <| singleton "y") (fromList [ "y", "x" ])
        , test "remove not existing key" <|
            \() -> Expect.equal (remove "x" (singleton "y")) (singleton "y")
        , test "remove existing key" <|
            \() -> Expect.equal (remove "x" (singleton "x")) empty
        ]


queryTests : Test
queryTests =
    describe "query tests"
        [ test "isEmpty True" <|
            \() -> Expect.equal (isEmpty empty) True
        , test "isEmpty False" <|
            \() -> Expect.equal (isEmpty (singleton "x")) False
        , test "member True" <|
            \() -> Expect.equal (member "x" (singleton "x")) True
        , test "member False" <|
            \() -> Expect.equal (member "y" (singleton "x")) False
        , test "size of empty" <|
            \() -> Expect.equal (size empty) 0
        , test "size" <|
            \() -> Expect.equal (size (fromList [ "x", "y" ])) 2
        ]


listTests : Test
listTests =
    let
        set =
            fromList [ "y", "x" ]
    in
    describe "list tests"
        [ test "fromList of duplicated values" <|
            \() -> Expect.equal (fromList [ "y", "x", "x", "y" ]) set
        , test "fromList of different order" <|
            \() -> Expect.notEqual (fromList [ "x", "y" ]) set
        , test "toList" <|
            \() -> Expect.equal (toList set) [ "y", "x" ]
        ]


transformTests : Test
transformTests =
    let
        set =
            fromList [ "y", "x" ]
    in
    describe "transform tests"
        [ test "map" <|
            \() ->
                Expect.equal (map (\k -> k ++ k) set)
                    (fromList [ "yy", "xx" ])
        , test "filter" <|
            \() -> Expect.equal (filter (\k -> k > "x") set) (singleton "y")
        , test "foldl" <|
            \() ->
                Expect.equal (foldl (\k acc -> k ++ acc) "" set) "xy"
        , test "foldr" <|
            \() ->
                Expect.equal (foldr (\k acc -> acc ++ k) "" set) "xy"
        , test "partition" <|
            \() ->
                Expect.equal (partition (\k -> k < "y") set)
                    ( singleton "x", singleton "y" )
        ]


combineTests : Test
combineTests =
    let
        set1 =
            fromList [ "y", "x" ]

        set2 =
            fromList [ "y", "z" ]
    in
    describe "combine tests"
        [ test "union" <|
            \() ->
                Expect.equal (union set1 set2)
                    (fromList [ "y", "x", "z" ])
        , test "intersect" <|
            \() ->
                Expect.equal (intersect set1 set2)
                    (fromList [ "y" ])
        , test "diff" <|
            \() ->
                Expect.equal (diff set1 set2)
                    (fromList [ "x" ])
        ]
