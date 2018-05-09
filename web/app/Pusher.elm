port module Pusher exposing (..)

import Model exposing (Cell)


port connect : String -> Cmd msg

port updateCell : (Cell -> msg) -> Sub msg
