module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)

import RemoteData exposing (WebData)

import Messages exposing (Msg(..))
import Model exposing(Cell, GameResponse)
import Pusher exposing (..)
import Game exposing (fetchGame, gameView)


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
    , board : WebData (List Cell)
    , game : WebData GameResponse
    }


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        OnPusherMessage pony ->
            ({ model | name = pony.name }, Cmd.none)
        TriggerPusherMessage message ->
            (model, Pusher.trigger message)
        InputUsername text ->
            ({ model | username = Just text }, Cmd.none)
        Submit ->
            case model.username of
                Nothing ->
                    (model, Cmd.none)
                Just username ->
                    (model, fetchGame username)
        OnCellClick x y ->
            ({ model
            | name = (toString x) ++ ":" ++ (toString y)
            },
            Cmd.none)
        OnFetchGame response ->
            (
                { model
                | game = response
                , route = Game
                },
                Cmd.none
            )

view : Model -> Html Msg
view model =
    case model.route of
        Game ->
            gameView model
        SignIn ->
            signInView model

signInView : Model -> Html Msg
signInView model =
    div []
        [ h1 [] [ text "Welcome to Pixel Wars!" ]
        , Html.form [ onSubmit Submit]
            [ label [] [ text "Enter a nickname" ]
            , input [ onInput InputUsername ] []
            , button [ type_ "submit" ] [ text "Go!" ]
            ]
        ]

gameView : Model -> Html Msg
gameView model =
    Game.gameView model.game


subscriptions : Model -> Sub Msg
subscriptions model =
    Pusher.messages OnPusherMessage


init : (Model, Cmd Msg)
init = (
    { name = "Random"
    , username = Nothing
    , route = SignIn
    , board = RemoteData.Loading
    , game = RemoteData.Loading
    },
    Cmd.none)
