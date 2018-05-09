module Model exposing(..)


type alias Cell =
    { x : Int
    , y : Int
    , color : Maybe String
    }

type alias User =
    { username : String
    , count : Int
    , color : String
    }

type alias GameResponse =
    { user : User
    , board : List Cell
    }