module Main exposing (..)

import Html exposing (..)

import Pusher exposing (..)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
    }


type alias Model =
    { name : String
    }


type Msg
    = OnPusherMessage Pony
    -- | msg2


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        OnPusherMessage pony ->
            ({ model | name = pony.name }, Cmd.none)


view : Model -> Html Msg
view model =
    div []
        [ text model.name ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Pusher.messages OnPusherMessage


init : (Model, Cmd Msg)
init = (
    { name = "Random"
    },
    Cmd.none)
