module Board exposing (..)

import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required, optional)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events exposing (..)

import Messages exposing (Msg(..))
import Model exposing (Cell, Board)
import User exposing (decodeUser)


boardDecoder : Decode.Decoder Board
boardDecoder = 
    decode Board
        |> required "width" Decode.int
        |> required "height" Decode.int
        |> required "cells" (Decode.list cellDecoder)

cellDecoder : Decode.Decoder Cell
cellDecoder =
    decode Cell
        |> required "x" Decode.int
        |> required "y" Decode.int
        |> optional "owner" (Decode.nullable decodeUser) Nothing

updateCell : Board -> Cell -> Board
updateCell board cell =
    let
        isTargetCell = (\x -> x.x == cell.x && x.y == cell.y)
        updateTargetCell = (\x -> if (isTargetCell x) then cell else x)
        cells = List.map updateTargetCell board.cells
    in
        { board
        | cells = cells
        }
            

boardView : Board -> Svg Msg
boardView board =
    let
        cell_width = 500 // board.width
        cell_height = 500 // board.height
        renderCell = cellView cell_width cell_height
    in
        svg [ viewBox "0 0 500 500", width "500px" ]
            (List.map renderCell board.cells)

cellView : Int -> Int -> Cell -> Svg Msg
cellView cell_width cell_height cell =
    let
        x1 = cell.x
        y1 = cell.y
        message = OnCellClick cell
        color = case cell.owner of
            Just user ->
                "#" ++ user.color
            Nothing ->
                "#eee"
    in
        rect [ x (toString (x1 * cell_width))
            , y (toString (y1 * cell_height))
            , width ((toString cell_width) ++ "px")
            , height ((toString cell_height) ++ "px")
            , stroke "#111"
            , fill color
            , onClick message
            ] []
