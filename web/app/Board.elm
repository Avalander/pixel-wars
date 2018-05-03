module Board exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required, optional)

import RemoteData exposing (WebData)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events exposing (..)

import Messages exposing (Msg(..))
import Model exposing (Cell)


fetchBoard : Cmd Msg
fetchBoard =
    Http.get "/api/board" boardDecoder
        |> RemoteData.sendRequest
        |> Cmd.map OnFetchBoard

boardDecoder : Decode.Decoder (List Cell)
boardDecoder = Decode.list cellDecoder

cellDecoder : Decode.Decoder Cell
cellDecoder =
    decode Cell
        |> required "x" Decode.int
        |> required "y" Decode.int
        |> optional "owner" (Decode.nullable Decode.string) Nothing

boardView : WebData (List Cell) -> Svg Msg
boardView response =
    case response of
        RemoteData.NotAsked ->
            text ""
        RemoteData.Loading ->
            text "Loading..."
        RemoteData.Success board ->
            svg [ viewBox "0 0 500 500", width "500px" ]
                (List.map cellView board)
        RemoteData.Failure error ->
            text (toString error)

-- boardView : Svg Msg
-- boardView =
--     svg [ viewBox "0 0 500 500", width "500px" ]
--         (List.map cellView board)

cellView : Cell -> Svg Msg
cellView cell =
    let
        x1 = cell.x
        y1 = cell.y
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
