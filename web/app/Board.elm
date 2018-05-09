module Board exposing (..)

import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required, optional)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events exposing (..)

import Messages exposing (Msg(..))
import Model exposing (Cell)


boardDecoder : Decode.Decoder (List Cell)
boardDecoder = Decode.list cellDecoder

cellDecoder : Decode.Decoder Cell
cellDecoder =
    decode Cell
        |> required "x" Decode.int
        |> required "y" Decode.int
        |> optional "color" (Decode.nullable Decode.string) Nothing

updateCell : (List Cell) -> Cell -> (List Cell)
updateCell board cell =
    let
        isTargetCell = (\x -> x.x == cell.x && x.y == cell.y)
        updateTargetCell = (\x -> if (isTargetCell x) then cell else x)
    in
        List.map updateTargetCell board
            

boardView : (List Cell) -> Svg Msg
boardView board =    
    svg [ viewBox "0 0 500 500", width "500px" ]
        (List.map cellView board)

cellView : Cell -> Svg Msg
cellView cell =
    let
        x1 = cell.x
        y1 = cell.y
        message = OnCellClick cell
        color = case cell.color of
            Just color ->
                color
            Nothing ->
                "#eee"
    in
        rect [ x (toString (x1 * 50))
            , y (toString (y1 * 50))
            , width "50px"
            , height "50px"
            , stroke "#111"
            , fill color
            , onClick message
            ] []
