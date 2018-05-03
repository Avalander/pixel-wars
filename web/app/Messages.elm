module Messages exposing (..)

import Model exposing (Cell)
import Pusher exposing (Pony)

import RemoteData exposing (WebData)

type Msg
    = OnPusherMessage Pony
    | TriggerPusherMessage String
    | InputUsername String
    | Submit
    | OnCellClick Int Int
    | OnFetchBoard (WebData (List Cell))

