module TestOrderedDict exposing (buildTests, conversionTests, queryTests, transformTests, updateTests)

import Dict
import Expect
import Fuzz exposing (int, list, tuple)
import OrderedDict exposing (..)
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
                singleton "one" 1
                    |> toList
                    |> Expect.equal [ ( "one", 1 ) ]
        , test "insert adds non-existant key last" <|
            \() ->
                fromList [ ( "one", 1 ), ( "two", 2 ) ]
                    |> insert "three" 3
                    |> toList
                    |> Expect.equal [ ( "one", 1 ), ( "two", 2 ), ( "three", 3 ) ]
        , test "insert adds existant key last" <|
            \() ->
                fromList [ ( "one", 1 ), ( "two", 2 ) ]
                    |> insert "one" 3
                    |> toList
                    |> Expect.equal [ ( "two", 2 ), ( "one", 3 ) ]
        , test "fromList takes last of duplicated keys" <|
            \() ->
                fromList [ ( "one", 1 ), ( "two", 2 ), ( "one", 3 ) ]
                    |> toList
                    |> Expect.equal [ ( "two", 2 ), ( "one", 3 ) ]
        , test "remove deletes existing key" <|
            \() ->
                fromList [ ( "one", 1 ), ( "two", 2 ), ( "three", 3 ) ]
                    |> remove "two"
                    |> toList
                    |> Expect.equal [ ( "one", 1 ), ( "three", 3 ) ]
        , test "removing then inserting a key adds it last" <|
            \() ->
                fromList [ ( "one", 1 ), ( "two", 2 ), ( "three", 3 ) ]
                    |> remove "two"
                    |> insert "two" 4
                    |> toList
                    |> Expect.equal [ ( "one", 1 ), ( "three", 3 ), ( "two", 4 ) ]
        , test "remove of non-existant key does nothing" <|
            \() ->
                fromList [ ( "one", 1 ), ( "two", 2 ), ( "three", 3 ) ]
                    |> remove "four"
                    |> toList
                    |> Expect.equal [ ( "one", 1 ), ( "two", 2 ), ( "three", 3 ) ]
        ]


updateTests : Test
updateTests =
    describe "update"
        [ test "updates existing key without changing its order" <|
            \() ->
                fromList [ ( "one", 1 ), ( "two", 2 ), ( "three", 3 ) ]
                    |> update "two" (always (Just 4))
                    |> toList
                    |> Expect.equal [ ( "one", 1 ), ( "two", 4 ), ( "three", 3 ) ]
        , test "updates non-existing key by adding value last" <|
            \() ->
                fromList [ ( "one", 1 ), ( "two", 2 ), ( "three", 3 ) ]
                    |> update "four" (always (Just 4))
                    |> toList
                    |> Expect.equal [ ( "one", 1 ), ( "two", 2 ), ( "three", 3 ), ( "four", 4 ) ]
        , test "removes existing key" <|
            \() ->
                fromList [ ( "one", 1 ), ( "two", 2 ), ( "three", 3 ) ]
                    |> update "two" (always Nothing)
                    |> toList
                    |> Expect.equal [ ( "one", 1 ), ( "three", 3 ) ]
        , test "removes and then inserting key adds it last" <|
            \() ->
                fromList [ ( "one", 1 ), ( "two", 2 ), ( "three", 3 ) ]
                    |> update "two" (always Nothing)
                    |> update "two" (always (Just 4))
                    |> toList
                    |> Expect.equal [ ( "one", 1 ), ( "three", 3 ), ( "two", 4 ) ]
        , test "removal of non-existant key changes nothing" <|
            \() ->
                fromList [ ( "one", 1 ), ( "two", 2 ), ( "three", 3 ) ]
                    |> update "four" (always Nothing)
                    |> toList
                    |> Expect.equal [ ( "one", 1 ), ( "two", 2 ), ( "three", 3 ) ]
        ]


queryTests : Test
queryTests =
    describe "query"
        [ test "isEmpty returns True for empty dict" <|
            \() -> Expect.equal (isEmpty empty) True
        , test "isEmpty returns False for non-empty dict" <|
            \() ->
                fromList
                    [ ( "one", 1 ) ]
                    |> isEmpty
                    |> Expect.equal False
        , fuzz (list (tuple ( int, int ))) "isEmpty matches Dict.isEmpty" <|
            \list ->
                Expect.equal
                    (Dict.fromList list |> Dict.isEmpty)
                    (fromList list |> isEmpty)
        , test "member detects existing key" <|
            \() ->
                fromList [ ( "one", 1 ), ( "two", 2 ), ( "three", 3 ) ]
                    |> member "two"
                    |> Expect.equal True
        , test "member detects missing key" <|
            \() ->
                fromList [ ( "one", 1 ), ( "two", 2 ), ( "three", 3 ) ]
                    |> member "four"
                    |> Expect.equal False
        , fuzz2 int (list (tuple ( int, int ))) "member matche Dict.member" <|
            \key list ->
                Expect.equal
                    (Dict.fromList list |> Dict.member key)
                    (fromList list |> member key)
        , test "get returns exising value" <|
            \() ->
                fromList [ ( "one", 1 ), ( "two", 2 ), ( "three", 3 ) ]
                    |> get "two"
                    |> Expect.equal (Just 2)
        , test "get returns non-existant value" <|
            \() ->
                fromList [ ( "one", 1 ), ( "two", 2 ), ( "three", 3 ) ]
                    |> get "four"
                    |> Expect.equal Nothing
        , fuzz2 int (list (tuple ( int, int ))) "get matches Dict.get" <|
            \key list ->
                Expect.equal
                    (Dict.fromList list |> Dict.get key)
                    (fromList list |> get key)
        , test "size of non-empty" <|
            \() ->
                fromList [ ( "one", 1 ), ( "two", 2 ) ]
                    |> size
                    |> Expect.equal 2
        , test "size of empty is 0" <|
            \() -> size empty |> Expect.equal 0
        , fuzz (list (tuple ( int, int ))) "size matches Dict.size" <|
            \list ->
                Expect.equal
                    (Dict.fromList list |> Dict.size)
                    (fromList list |> size)
        ]


conversionTests : Test
conversionTests =
    describe "conversions"
        [ test "keys" <|
            \() ->
                fromList [ ( "one", 1 ), ( "two", 2 ), ( "three", 3 ) ]
                    |> keys
                    |> Expect.equal [ "one", "two", "three" ]
        , test "values" <|
            \() ->
                fromList [ ( "one", 1 ), ( "two", 2 ), ( "three", 3 ) ]
                    |> values
                    |> Expect.equal [ 1, 2, 3 ]
        , test "fromList" <|
            \() ->
                fromList [ ( "one", 1 ), ( "two", 2 ), ( "three", 3 ) ]
                    |> toList
                    |> Expect.equal
                        [ ( "one", 1 ), ( "two", 2 ), ( "three", 3 ) ]
        , test "fromList distinguishes different orders" <|
            \() ->
                Expect.notEqual
                    (fromList [ ( "one", 1 ), ( "two", 2 ), ( "three", 3 ) ])
                    (fromList [ ( "two", 2 ), ( "one", 1 ), ( "three", 3 ) ])
        , fuzz (list (tuple ( int, int ))) "toList and fromList reverse each other" <|
            \list ->
                let
                    orderedDict =
                        fromList list
                in
                toList orderedDict
                    |> fromList
                    |> Expect.equal orderedDict
        , fuzz (list (tuple ( int, int ))) "toDict" <|
            \list ->
                fromList list
                    |> toDict
                    |> Expect.equal (Dict.fromList list)
        ]


transformTests : Test
transformTests =
    describe "transform"
        [ fuzz (list (tuple ( int, int ))) "map matches List.map" <|
            \list ->
                let
                    orderedDict =
                        fromList list

                    func k v =
                        k + v
                in
                Expect.equal
                    (toList orderedDict
                        |> List.map
                            (\( k, v ) -> ( k, func k v ))
                    )
                    (map func orderedDict |> toList)
        , fuzz (list (tuple ( int, int ))) "filter matches List.filter" <|
            \list ->
                let
                    orderedDict =
                        fromList list

                    func k v =
                        ((k + v) |> modBy 2) == 0
                in
                Expect.equal
                    (toList orderedDict
                        |> List.filter
                            (\( k, v ) -> func k v)
                    )
                    (filter func orderedDict |> toList)
        , fuzz (list (tuple ( int, int ))) "foldl matches List.foldl" <|
            \list ->
                let
                    orderedDict =
                        fromList list

                    {- In order to test the difference between foldl and foldr,
                       this function is not commutative (i. e. order of operations matter).
                    -}
                    func k v acc =
                        (k + v) :: acc

                    initAcc =
                        []
                in
                Expect.equal
                    (toList orderedDict
                        |> List.foldl
                            (\( k, v ) acc -> func k v acc)
                            initAcc
                    )
                    (foldl func initAcc orderedDict)
        , fuzz (list (tuple ( int, int ))) "foldr matches List.foldr" <|
            \list ->
                let
                    orderedDict =
                        fromList list

                    {- In order to test the difference between foldl and foldr,
                       this function is not commutative (i. e. order of operations matter).
                    -}
                    func k v acc =
                        (k + v) :: acc

                    initAcc =
                        []
                in
                Expect.equal
                    (toList orderedDict
                        |> List.foldr
                            (\( k, v ) acc -> func k v acc)
                            initAcc
                    )
                    (foldr func initAcc orderedDict)
        , fuzz (list (tuple ( int, int ))) "partition matches List.partition" <|
            \list ->
                let
                    orderedDict =
                        fromList list

                    func k v =
                        ((k + v) |> modBy 2) == 0
                in
                Expect.equal
                    (toList orderedDict
                        |> List.partition
                            (\( k, v ) -> func k v)
                    )
                    (partition func orderedDict |> Tuple.mapBoth toList toList)
        ]
