module Messages exposing (..)

import Model exposing (Cell, GameResponse, ClaimCellResponse)

import RemoteData exposing (WebData)

type Msg
    = OnUpdateCell Cell
    | InputUsername String
    | Submit
    | OnCellClick Cell
    | OnFetchGame (WebData GameResponse)
    | OnClaimCell (WebData ClaimCellResponse)

