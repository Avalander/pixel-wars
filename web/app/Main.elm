module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onSubmit)

import RemoteData exposing (WebData)

import Messages exposing (Msg(..))
import Model exposing(Cell)
import Pusher exposing (..)
import Board exposing (boardView, fetchBoard)


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
            ({ model | route = Game }, Cmd.none)
        OnCellClick x y ->
            ({ model
            | name = (toString x) ++ ":" ++ (toString y)
            },
            Cmd.none)
        OnFetchBoard response ->
            ({ model | board = response }, Cmd.none)

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
    div []
        [ boardView model.board
        , text model.name
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Pusher.messages OnPusherMessage


init : (Model, Cmd Msg)
init = (
    { name = "Random"
    , username = Nothing
    , route = SignIn
    , board = RemoteData.Loading
    },
    fetchBoard)
