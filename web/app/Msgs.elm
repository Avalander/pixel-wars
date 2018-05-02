module Msgs exposing (..)

import Pusher exposing (Pony)

type Msg
    = OnPusherMessage Pony
    | TriggerPusherMessage String
    | InputUsername String
    | Submit
    | OnCellClick Int Int
