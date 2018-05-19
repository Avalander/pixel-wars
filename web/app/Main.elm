module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)

import RemoteData exposing (WebData)

import Messages exposing (Msg(..))
import Model exposing(Cell, GameResponse, User, Board)
import Pusher exposing (..)
import Game exposing (fetchGame, gameView, claimCell)
import Board exposing (updateCell)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
    }


type Route = SignIn
    | Game

type alias Model =
    { name : String
    , username : Maybe String
    , route : Route
    , board : Model.Board
    , user : User
    }


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        InputUsername text ->
            ({ model | username = Just text }, Cmd.none)
        Submit ->
            case model.username of
                Nothing ->
                    (model, Cmd.none)
                Just username ->
                    (model, fetchGame username)
        OnCellClick cell ->
            ({ model
            | name = (toString cell.x) ++ ":" ++ (toString cell.y)
            },
            claimCell cell)
        OnFetchGame response ->
            case response of
                RemoteData.NotAsked ->
                    (model, Cmd.none)
                RemoteData.Loading ->
                    (model, Cmd.none)
                RemoteData.Success { board, user } ->
                    (
                        { model
                        | board = board
                        , user = user
                        , route = Game
                        },
                        Pusher.connect "connect"
                    )
                RemoteData.Failure error ->
                    (model, Cmd.none)
        OnClaimCell response ->
            case response of
                RemoteData.NotAsked ->
                    (model, Cmd.none)
                RemoteData.Loading ->
                    (model, Cmd.none)
                RemoteData.Success response ->
                    ({ model
                    | board = response.board
                    }, Cmd.none)
                RemoteData.Failure error ->
                    (model, Cmd.none)
        OnUpdateCell cell ->
            (
                { model
                | board = (Board.updateCell model.board cell)
                },
                Cmd.none
            )


view : Model -> Html Msg
view model =
    case model.route of
        Game ->
            gameView model.board model.user
        SignIn ->
            signInView model

signInView : Model -> Html Msg
signInView model =
    div [ class "panel column w600" ]
        [ h1 [] [ text "Welcome to Pixel Wars!" ]
        , Html.form [ class "column form-group", onSubmit Submit]
            [ label [] [ text "Enter a nickname" ]
            , input [ onInput InputUsername ] []
            , div [ class "center m10" ]
                [ button [ class "btn primary", type_ "submit" ] [ text "Go!" ]
                ]
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Pusher.updateCell OnUpdateCell


init : (Model, Cmd Msg)
init = (
    { name = "Random"
    , username = Nothing
    , route = SignIn
    , board = { width = 50, height = 50, cells = [] }
    , user = { username = "", count = 0, color = "" }
    },
    Cmd.none)
