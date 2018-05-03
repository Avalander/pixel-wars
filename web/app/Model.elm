module Model exposing(..)


type alias Cell =
    { x : Int
    , y : Int
    , owner : Maybe String
    }