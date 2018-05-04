module Model exposing(..)


type alias Cell =
    { x : Int
    , y : Int
    , owner : Maybe String
    }

type alias GameResponse =
    { username : String
    , board : List Cell
    }