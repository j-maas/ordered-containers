module TestOrderedSet exposing (buildTests, conversionTests, queryTests, transformTests)

import Expect
import Fuzz exposing (int, list)
import OrderedSet exposing (..)
import Set
import Test exposing (Test, describe, fuzz, fuzz2, test)


buildTests : Test
buildTests =
    describe "build"
        [ test "empty" <|
            \() ->
                empty
                    |> toList
                    |> Expect.equal []
        , test "singleton" <|
            \() ->
                singleton 1
                    |> toList
                    |> Expect.equal [ 1 ]
        , test "insert adds non-existant key last" <|
            \() ->
                fromList [ 2, 3 ]
                    |> insert 1
                    |> toList
                    |> Expect.equal [ 2, 3, 1 ]
        , test "insert moves existant key to last" <|
            \() ->
                fromList [ 1, 2, 3 ]
                    |> insert 1
                    |> toList
                    |> Expect.equal [ 2, 3, 1 ]
        , test "remove existant key" <|
            \() ->
                fromList [ 1, 2, 3 ]
                    |> remove 2
                    |> toList
                    |> Expect.equal [ 1, 3 ]
        , test "remove with non-existant key changes nothing" <|
            \() ->
                fromList [ 1, 2, 3 ]
                    |> remove 4
                    |> toList
                    |> Expect.equal [ 1, 2, 3 ]
        ]


queryTests : Test
queryTests =
    describe "query"
        [ test "isEmpty returns True for empty set" <|
            \() ->
                isEmpty empty
                    |> Expect.equal True
        , test "isEmpty returns False for non-empty set" <|
            \() ->
                fromList [ 1 ]
                    |> isEmpty
                    |> Expect.equal False
        , fuzz (list int) "isEmpty matches Set.isEmpty" <|
            \list ->
                Expect.equal
                    (Set.fromList list |> Set.isEmpty)
                    (fromList list |> isEmpty)
        , test "member detects existing key" <|
            \() ->
                fromList [ 1, 2, 3 ]
                    |> member 2
                    |> Expect.equal True
        , test "member detects missing key" <|
            \() ->
                fromList [ 1, 2, 3 ]
                    |> member 4
                    |> Expect.equal False
        , fuzz2 int (list int) "member matchs Set.member" <|
            \key list ->
                Expect.equal
                    (Set.fromList list |> Set.member key)
                    (fromList list |> member key)
        , test "size of empty is 0" <|
            \() ->
                size empty
                    |> Expect.equal 0
        , test "size" <|
            \() ->
                fromList [ 1, 2 ]
                    |> size
                    |> Expect.equal 2
        , fuzz (list int) "size matches Set.size" <|
            \list ->
                Expect.equal
                    (Set.fromList list |> Set.size)
                    (fromList list |> size)
        ]


conversionTests : Test
conversionTests =
    describe "conversions"
        [ test "fromList of duplicated values" <|
            \() ->
                fromList [ 1, 2, 1, 3 ]
                    |> toList
                    |> Expect.equal [ 2, 1, 3 ]
        , test "fromList distinguishes different orders" <|
            \() ->
                Expect.notEqual
                    (fromList [ 1, 2, 3 ])
                    (fromList [ 2, 1, 3 ])
        , fuzz (list int) "toList and fromList reverse each other" <|
            \list ->
                let
                    set =
                        fromList list
                in
                toList set
                    |> fromList
                    |> Expect.equal set
        , fuzz (list int) "toSet" <|
            \list ->
                fromList list
                    |> toSet
                    |> Expect.equal (Set.fromList list)
        ]


transformTests : Test
transformTests =
    describe "transform"
        [ fuzz (list int) "map matches List.map" <|
            \list ->
                let
                    orderedSet =
                        fromList list

                    func k =
                        k + 1
                in
                Expect.equal
                    (toList orderedSet
                        |> List.map
                            (\k -> func k)
                    )
                    (map func orderedSet |> toList)
        , fuzz (list int) "filter matches List.filter" <|
            \list ->
                let
                    orderedSet =
                        fromList list

                    func k =
                        (k |> modBy 2) == 0
                in
                Expect.equal
                    (toList orderedSet
                        |> List.filter
                            (\k -> func k)
                    )
                    (filter func orderedSet |> toList)
        , fuzz (list int) "foldl matches List.foldl" <|
            \list ->
                let
                    orderedSet =
                        fromList list

                    {- In order to test the difference between foldl and foldr,
                       this function is not commutative (i. e. order of operations matter).
                    -}
                    func k acc =
                        k :: acc

                    initAcc =
                        []
                in
                Expect.equal
                    (toList orderedSet
                        |> List.foldl
                            func
                            initAcc
                    )
                    (foldl func initAcc orderedSet)
        , fuzz (list int) "foldr matches List.foldr" <|
            \list ->
                let
                    orderedSet =
                        fromList list

                    {- In order to test the difference between foldl and foldr,
                       this function is not commutative (i. e. order of operations matter).
                    -}
                    func k acc =
                        k :: acc

                    initAcc =
                        []
                in
                Expect.equal
                    (toList orderedSet
                        |> List.foldr
                            func
                            initAcc
                    )
                    (foldr func initAcc orderedSet)
        , fuzz (list int) "partition matches List.partition" <|
            \list ->
                let
                    orderedSet =
                        fromList list

                    func k =
                        (k |> modBy 2) == 0
                in
                Expect.equal
                    (toList orderedSet
                        |> List.partition
                            func
                    )
                    (partition func orderedSet |> Tuple.mapBoth toList toList)
        ]
