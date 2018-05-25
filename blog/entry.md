---
title: Pixel Wars: Contest Entry
published: false
description: An app submitted to the first-ever DEV Community contest. 
tags: pushercontest, pixelwars, elm
---

# What I built

I built a multiplayer browser game inspired by [r/Place](https://en.wikipedia.org/wiki/Place_(Reddit)). The goal of the game is to control most of the board. The board has (currently) 625 cells, and the player can claim any cell by clicking on it.

If you've followed my blog entries, you'll notice that I ended up not adding any limitations to claiming cells. The players can claim cells to their hearts content, without having to wait for other players or being limited in any other way.

Also, there is no wining condition. The plan was that the game would run forever (or until I decide to bring it down). Maybe it doesn't make for the most exciting game of the year, but it was interesting enough to play around with Pusher.

## Demo Link

[The game can be played here](https://projects.avalander.com/).

## Link to Code

The code is available on [GitHub](https://github.com/Avalander/pixel-wars).

# How I built it (what's the stack? did I run into issues or discover something new along the way?)

I used [Elm](https://elm-lang.org) for the frontend. I had tried it before, but I haven't built anything big with it yet and I'm still learning, so it was great to deepend my knowledge of the language as well. One thing that I hadn't encountered before and I had to solve for this project was to figure out how to make Elm interact with a Javascript library, which turned out to be easier than I expected. Probably because both Elm's Javascript interoperability and Pusher API are designed around subscriptions and passing messages around.

The backend is built using node.js. I wanted to try to capture the HTTP requests into streams that I would map and reduce to build the game state, and use listeners to dispatch messages through Pusher. I toyed with the concept a couple of hours, but solving it in a clean way turned out to be non-trivial, so I abandoned the idea due to lack of time.

Check additional resources a bit below for more info!

# How I used Pusher

The whole point of the game is that each player needs to see updates to the board on real time. Therefore, whenever a player claims a cell, a message is sent to all connected players through Pusher with the updated cell.

I implemented a leaderboard, with the count of how many cells currently belong to each player, that displays the ten players with the highest score. The updates to the leaderboard are achieved through Pusher as well.

There's no real need to update the leaderboard in real time, it could be updated every few seconds, or every few minutes even. Therefore, I wanted to decouple it from updating the board cells. Since I don't expect much traffic, however, I don't need to be cheap with Pusher messages, and I'm sending updates every time a user claims a cell as well.

# Additional Resources/Info 

I wrote a few posts documenting my process and findings. You can check them here.

[Design](https://dev.to/avalander/pixel-wars-design-358p)
[Using Pusher in Elm](https://dev.to/avalander/pixel-wars-using-pusher-in-elm-4ifb)
[Claim Cells](https://dev.to/avalander/pixel-wars-claim-cells-191g)

That's all folks! Please, give the game a try, and any comments are welcome.

