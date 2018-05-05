---
title: Pixel Wars: Using Pusher in Elm
description:
published: false
tags: pushercontest, pixelwars, game, elm
---

[View the project on GitHub](https://github.com/Avalander/pixel-wars)

Since I'm using Elm in my project, I needed to figure out how to use Pusher in Elm, because there is no Pusher client for it. Fortunately, Elm offers a very clean and nice way to interact with Javascript. I was positively surprised by how easy it actually was.

# Using Pusher in Elm

Let's start with the code. Here's how I did it.

First, I declared two ports in an Elm module.

```elm
port module Pusher

port messages : (Pony -> msg) -> Sub msg

port connect : String -> Cmd msg
```

* `messages` will be invoked from Javascript every time the Pusher subscription receives a message. Nevermind the type `Pony`, that's going to change when I implement updating the game state in the backend.
* `connect` will be invoked from Elm to create the Pusher connection. Javascript will listen to that message and open the connection.

Let's have a look at the Javascript code required to make this work.

```javascript
import Elm from 'app/Main.elm'
import Pusher from 'pusher-js'

const mount_node = document.querySelector('#root')
const app = Elm.Main.embed(mount_node)
let pusher

app.ports.connect.subscribe((() => {
    pusher = new Pusher(PUSHER_KEY, {
        encrypted: true,
    })
    pusher.subscribe('ponies')
        .bind('pony-data', app.ports.messages.send)
}))
```

All functions prefixed with `port` in Elm are exposed in Javascript in the object `app.ports`. Therefore, I can call `app.ports.connect.subscribe` to run a callback in Javascript when the `Pusher.connect` command is executed in Elm. In a similar fashion, I can call `app.ports.messages.send` to invoke the function `messages` in Elm.

To glue everything in Elm, I need to subscribe to the function `messages`, and return the command `connect` in the `update` function when I want to connect to pusher. Here's how I did it in my `Main.elm`.

```elm
import Pusher exposing (..)

type Msg
    = OnPusherMessage Pony
    | OnFetchGame (WebData GameResponse)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        OnPusherMessage pony ->
            ({ model | name = pony.name }, Cmd.none)
        OnFetchGame response ->
            (
                updateModel model response,
                Pusher.connect "connect"
            )

subscriptions : Model -> Sub Msg
subscriptions model =
    Pusher.messages OnPusherMessage
```

There we go. Adding `Pusher.messages` in the subscriptions will trigger a `OnPusherMessage` with the received message every time `app.ports.message.send` is invoked in Javascript. Similarly, returning `Pusher.connect` in `update` will send an event to `app.ports.connect` when the client has received the game state, so that updates can start flowing.

# Next Steps

The next step is to make the client send clicks to the server and have the server update the game state and send it back to all connected clients. Hopefully I'll have something functional enough to be deployed in a couple of days.