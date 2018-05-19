import 'index.scss'

import Elm from 'app/Main.elm'

import Pusher from 'pusher-js'


const mount_node = document.querySelector('#root')

const app = Elm.Main.embed(mount_node)

let pusher

app.ports.connect.subscribe(() => {
	pusher = new Pusher(PUSHER_KEY, {
		cluster: 'eu',
		encrypted: true,
	})
	const channel = pusher.subscribe('game-updates')
	channel.bind('update-cell', app.ports.updateCell.send)
	channel.bind('update-leaderboard', app.ports.updateLeaderboard.send)
	
	console.log('Connected!')
})
