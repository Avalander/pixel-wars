module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)

import RemoteData exposing (WebData)

import Messages exposing (Msg(..))
import Model exposing(Cell, GameResponse)
import Pusher exposing (..)
import Game exposing (fetchGame, gameView, claimCell)


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
    , board : List Cell
    , game : WebData GameResponse
    }


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        OnPusherMessage pony ->
            ({ model | name = pony.name }, Cmd.none)
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
            (
                { model
                | game = response
                , route = Game
                },
                Pusher.connect "connect"
            )
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


view : Model -> Html Msg
view model =
    case model.route of
        Game ->
            gameView model.game
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
    Pusher.messages OnPusherMessage


init : (Model, Cmd Msg)
init = (
    { name = "Random"
    , username = Nothing
    , route = SignIn
    , board = []
    , game = RemoteData.Loading
    },
    Cmd.none)
