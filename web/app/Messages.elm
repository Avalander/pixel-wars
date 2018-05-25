module Messages exposing (..)

import Model exposing (Cell, GameResponse, ClaimCellResponse, Leaderboard)

import RemoteData exposing (WebData)

type Msg
    = OnUpdateCell Cell
    | OnUpdateLeaderboard Leaderboard
    | InputUsername String
    | Submit
    | OnCellClick Cell
    | OnFetchGame (WebData GameResponse)
    | OnClaimCell (WebData ClaimCellResponse)

