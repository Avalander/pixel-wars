module Game exposing (fetchGame, claimCell, gameView)

import Html exposing (Html, text, div, span)
import Html.Attributes exposing (class, style)

import Http
import Json.Encode as Encode
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required, optional)

import RemoteData exposing (WebData)

import Messages exposing (Msg(..))
import Model exposing (Cell, GameResponse, User, ClaimCellResponse)
import Board exposing (boardDecoder, boardView)


-- FETCH GAME

fetchGame : String -> Cmd Msg
fetchGame username =
    Http.post "/api/register" (encodeGameRequest username) gameResponseDecoder
        |> RemoteData.sendRequest
        |> Cmd.map OnFetchGame

gameResponseDecoder : Decode.Decoder GameResponse
gameResponseDecoder =
    decode GameResponse
        |> required "user" decodeUser
        |> required "board" boardDecoder

encodeGameRequest : String -> Http.Body
encodeGameRequest username =
    username
        |> Encode.string
        |> (\x -> Encode.object [("username", x)])
        |> Http.jsonBody

decodeUser : Decode.Decoder User
decodeUser =
    decode User
        |> required "username" Decode.string
        |> required "count" Decode.int
        |> required "color" Decode.string


-- CLAIM CELL

claimCell : Cell -> Cmd Msg
claimCell cell =
    Http.post "/api/claim" (encodeClaimCellRequest cell) claimCellResponseDecoder
        |> RemoteData.sendRequest
        |> Cmd.map OnClaimCell

claimCellResponseDecoder : Decode.Decoder ClaimCellResponse
claimCellResponseDecoder =
    decode ClaimCellResponse
        |> required "board" boardDecoder

encodeClaimCellRequest : Cell -> Http.Body
encodeClaimCellRequest cell =
    cell
        |> (\{ x, y } -> Encode.object
            [ ("x", Encode.int x)
            , ("y", Encode.int y)
            ])
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
successView { user, board } =
    div []
        [ renderHeader user
        , boardView board
        ]

userToString : User -> String
userToString { username, count } =
    username ++ " #" ++ (toString count)

renderHeader : User -> Html Msg
renderHeader user =
    div [ class "header" ]
        [ span [ class "color-box"
               , style [("backgroundColor", "#" ++ user.color), ("color", "#" ++ user.color)] ]
               [ text "TS" ]
        , text (userToString user)
        ]

loadingView : Html Msg
loadingView =
    text "Loading..."

notAskedView : Html Msg
notAskedView =
    text "You shouldn't see this."

errorView : Http.Error -> Html Msg
errorView error =
    text (toString error)