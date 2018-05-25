module Model exposing(..)


type alias Board =
    { width : Int
    , height : Int
    , cells : List Cell
    }

type alias Cell =
    { x : Int
    , y : Int
    , owner : Maybe User
    }

type alias User =
    { username : String
    , count : Int
    , color : String
    }

type alias GameResponse =
    { user : User
    , board : Board
    }

type alias ClaimCellResponse =
    { board : Board
    }

type alias LeaderboardEntry =
    { amount : Int
    , user : User
    }

type alias Leaderboard =
    List LeaderboardEntry