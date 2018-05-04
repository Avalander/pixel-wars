---
title: Pixel Wars: Update 1
published: false
tags: pushercontest, pixelwars, game
---

# Using Pusher in Elm

There is no Pusher client for Elm, so I had to use some Javascript and interface it with Elm. That is suprisingly easy.

This is the Javascript I needed to initialise the Elm application and Pusher.

```javascript
import Elm from 'app/Main.elm'
import Pusher from 'pusher-js'


const mount_node = document.querySelector('#root')
const app = Elm.Main.embed(mount_node)

const pusher = new Pusher(PUSHER_KEY, {
	cluster: 'eu',
	encrypted: true,
})

pusher.subscribe('ponies')
	.bind('pony-data', app.ports.messages.send)
```

And this is the Elm code interfacing with Javascript.

```elm
port module Pusher exposing (..)

type alias Pony =
    { name : String
    }

port messages : (Pony -> msg) -> Sub msg
```

Basically, `port messages : (Pony -> msg) -> Sub msg`