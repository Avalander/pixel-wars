---
title: Pixel Wars: Claim Cells
description:
published: false
tags: pushercontest, pixelwars, game, elm
---

[View the project on GitHub](https://github.com/Avalander/pixel-wars)

[Try it out!](https://projects.avalander.com)

# Progress so far

The most interesting news is that I have a [playable demo](https://projects.avalander.com) now!

When the player visits the game, they are asked to choose a nickname and get a random colour assigned. To avoid having to handle duplicated nicknames, the player gets a number with their nickname. Therefore, the first player to sign up with the name *James* will be *James #0*, the second one, *James #1* and so forth.

Then, the player can start claiming cells of the board. When a player claims a cell, the cell will be drawn with the player's colour, and any other connected players will see the board update in real time.

# Next steps

First thing, I will make the board larger. One hundred cells seem very little. I'm thinking that the board should be configurable in the backend and the client should receive the dimensions of the board and draw it accordingly, instead of having them harcoded both in the client and in the server.

Then, I still have two rules to implement from the original design:
* A player can only claim a cell if nobody has previously claimed any cell or after a different player has claimed a cell, i.e., a player cannot claim two cells consecutively.
* To ease the previous rule when there are few players, there will be a bot that will claim a random cell if no player has claimed any cell in 2 minutes, or when there are no players connected.

I'm not entirely sure about these rules, though. The goal is to avoid a situation where one player is the only one connected and quickly claims the whole board, hence the idea of disallowing claiming multiple cells consecutively. Another idea that I'm considering is to add a cooldown after the player has claimed a few cells.

For instance, a player could claim up to five cells and then have a cooldown of a few minutes, which would be less aggressive than not allowing to claim more than one cell in a row. The cooldown could be affected by the amount of players online and be reduced whenever another player claims a cell. This would have the additional benefit that I would have a few other interesting things to do with Pusher.

Anyway, I'm not entirely sure what would be a good way to prevent one player claiming the whole board in a matter of seconds when nobody else is online. Suggestions and opinions on the two solutions I mentioned above are welcome.

And the last thing that I have planned to implement is a leaderboard. Next to the board, the player should see a leaderboard with the 10 players that own more cells at the moment and the 10 players that have claimed more cells in total.
