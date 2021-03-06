module Game exposing (fetchGame, claimCell, gameView)

import Html exposing (Html, text, div, span)
import Html.Attributes exposing (class, style)

import Http
import Json.Encode as Encode
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required, optional)

import RemoteData exposing (WebData)

import Messages exposing (Msg(..))
import Model exposing (Cell, GameResponse, User, ClaimCellResponse, Board, Leaderboard)
import Board exposing (boardDecoder, boardView)
import User exposing (decodeUser, userToString)
import Leaderboard


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

gameView : Board -> User -> Leaderboard -> Html Msg
gameView board user leaderboard =
    div [ class "game-view" ]
        [ div []
              [ renderHeader user
              , boardView board 
              ]
        , Leaderboard.view leaderboard
        ]

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