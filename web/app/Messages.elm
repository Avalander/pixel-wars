module Messages exposing (..)

import Model exposing (Cell, GameResponse)
import Pusher exposing (Pony)

import RemoteData exposing (WebData)

type Msg
    = OnPusherMessage Pony
    | InputUsername String
    | Submit
    | OnCellClick Int Int
    | OnFetchGame (WebData GameResponse)

