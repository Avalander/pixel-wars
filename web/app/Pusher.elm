port module Pusher exposing (..)

type alias Pony =
    { name : String
    }

port messages : (Pony -> msg) -> Sub msg

port connect : String -> Cmd msg
