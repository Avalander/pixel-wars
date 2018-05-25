module Leaderboard exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)

import Model exposing (Leaderboard, LeaderboardEntry)
import User exposing (userToString)


view : Leaderboard -> Html msg
view leaderboard =
    div [ class "leaderboard" ]
        (List.concat
            [ [ h1 [] [ text "Leaderboard" ]]
            , [ renderHeaders ]
            , (List.map renderRow leaderboard)
            ])

renderHeaders : Html msg
renderHeaders =
    div [ class "row" ]
        [ div [ class "column" ]
            [ text "User" ]
        , div [ class "column" ]
            [ text "Cells" ]
        ]

renderRow : LeaderboardEntry -> Html msg
renderRow { amount, user } =
    div [ class "row" ]
        [ div [ class "column" ]
              [ div [ class "color-box"
                     , style [("backgroundColor", "#" ++ user.color), ("color", "#" ++ user.color)]
                     ] [ text "" ]
              , span [ class "column" ] [ text (userToString user) ]
              ]
        , span [ class "column" ] [ text (toString amount) ]
        ]
