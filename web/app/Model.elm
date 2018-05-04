module Model exposing(..)


type alias Cell =
    { x : Int
    , y : Int
    , color : Maybe String
    }

type alias GameResponse =
    { username : String
    , board : List Cell
    }