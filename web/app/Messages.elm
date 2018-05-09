module Messages exposing (..)

import Model exposing (Cell, GameResponse, ClaimCellResponse)
import Pusher exposing (Pony)

import RemoteData exposing (WebData)

type Msg
    = OnPusherMessage Pony
    | InputUsername String
    | Submit
    | OnCellClick Cell
    | OnFetchGame (WebData GameResponse)
    | OnClaimCell (WebData ClaimCellResponse)

