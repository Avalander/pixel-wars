module User exposing (..)

import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required, optional)

import Model exposing (User)


decodeUser : Decode.Decoder User
decodeUser =
    decode User
        |> required "username" Decode.string
        |> required "count" Decode.int
        |> required "color" Decode.string

userToString : User -> String
userToString { username, count } =
    username ++ " #" ++ (toString count)
