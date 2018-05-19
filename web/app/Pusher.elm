port module Pusher exposing (..)

import Model exposing (Cell, Leaderboard)


port connect : String -> Cmd msg

port updateCell : (Cell -> msg) -> Sub msg

port updateLeaderboard : (Leaderboard -> msg) -> Sub msg
