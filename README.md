**Pixel Wars** will be my entry for the [First Ever DEV Contest](https://dev.to/devteam/first-ever-dev-contest-build-a-realtime-app-with-pusher-4nhp).

**Pixel Wars** is a web game inspired by [Reddit Place](https://en.wikipedia.org/wiki/Place_(Reddit)). The game will have a square canvas with a number of cells. The player can click on a cell to claim it, and the goal is to have as many cells as possible.

# Game rules

* The game board is a square canvas with a number of cells to be defined.
* When the player clicks on a cell, the cell is assigned to that player.
* A player can only claim a cell if nobody has previously claimed any cell or after a different player has claimed a cell, i.e., a player cannot claim two cells consecutively.
* To ease the previous rule when there are few players, there will be a bot that will claim a random cell if no player has claimed any cell in 2 minutes, or when there are no players connected.
* The game session will (most probably) not be preserved between connections. When a player leaves the game and comes back later, it will be considered a new player.

# How am I going to use Pusher?

This is a real time game in the sense that when a player claims a cell, all other players must be notified as soon as possible. Therefore, I'm going to send updates to the game board using Pusher. Also, the game will have a leaderboard featuring the players with most cells claimed currently and in total. The leaderboard will also be updated in real time using Pusher.

# Tech stack

I will create a simple backend with Node and MongoDB and I will use Elm in the frontend.

That was my introduction. I hope to see plenty of entries, and good luck to everybody participating in the challenge!