module Board exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events exposing (..)

import Msgs exposing (Msg(..))


board : List (Int, Int)
board = List.concat
    [ List.map2 (,) (List.range 0 9) (List.repeat 10 0)
    , List.map2 (,) (List.range 0 9) (List.repeat 10 1)
    , List.map2 (,) (List.range 0 9) (List.repeat 10 2)
    , List.map2 (,) (List.range 0 9) (List.repeat 10 3)
    , List.map2 (,) (List.range 0 9) (List.repeat 10 4)
    , List.map2 (,) (List.range 0 9) (List.repeat 10 5)
    , List.map2 (,) (List.range 0 9) (List.repeat 10 6)
    , List.map2 (,) (List.range 0 9) (List.repeat 10 7)
    , List.map2 (,) (List.range 0 9) (List.repeat 10 8)
    , List.map2 (,) (List.range 0 9) (List.repeat 10 9)
    ]

boardView : Svg Msg
boardView =
    svg [ viewBox "0 0 500 500", width "500px" ]
        (List.map cellView board)

cellView : (Int, Int) -> Svg Msg
cellView (x1, y1) =
    let
        message = OnCellClick x1 y1
    in
        rect [ x (toString (x1 * 50))
            , y (toString (y1 * 50))
            , width "50px"
            , height "50px"
            , stroke "#111"
            , fill "#eee"
            , onClick message
            ] []
