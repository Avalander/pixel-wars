module Game exposing (fetchGame, gameView)

import Html exposing (Html, text, div)
import Html.Attributes exposing (class)

import Http
import Json.Encode as Encode
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required, optional)

import RemoteData exposing (WebData)

import Messages exposing (Msg(..))
import Model exposing (Cell, GameResponse)
import Board exposing (boardDecoder, boardView)


-- REQUEST

fetchGame : String -> Cmd Msg
fetchGame username =
    Http.post "/api/register" (encodeGameRequest username) gameResponseDecoder
        |> RemoteData.sendRequest
        |> Cmd.map OnFetchGame

gameResponseDecoder : Decode.Decoder GameResponse
gameResponseDecoder =
    decode GameResponse
        |> required "username" Decode.string
        |> required "board" boardDecoder

encodeGameRequest : String -> Http.Body
encodeGameRequest username =
    username
        |> Encode.string
        |> (\x -> Encode.object [("username", x)])
        |> Http.jsonBody


-- VIEW

gameView : (WebData GameResponse) -> Html Msg
gameView response =
    case response of
        RemoteData.Loading ->
            loadingView
        RemoteData.NotAsked ->
            notAskedView
        RemoteData.Success game ->
            successView game
        RemoteData.Failure error ->
            errorView error

successView : GameResponse -> Html Msg
successView { username, board } =
    div []
        [ renderHeader username
        , boardView board
        ]

renderHeader : String -> Html Msg
renderHeader username =
    div [ class "header" ]
        [ text username ]

loadingView : Html Msg
loadingView =
    text "Loading..."

notAskedView : Html Msg
notAskedView =
    text "You shouldn't see this."

errorView : Http.Error -> Html Msg
errorView error =
    text (toString error)