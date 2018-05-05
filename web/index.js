import 'index.scss'

import Elm from 'app/Main.elm'

import Pusher from 'pusher-js'


const mount_node = document.querySelector('#root')

const app = Elm.Main.embed(mount_node)

let pusher

app.ports.connect.subscribe((() => {
	pusher = new Pusher(PUSHER_KEY, {
		cluster: 'eu',
		encrypted: true,
	})
	pusher.subscribe('ponies')
		.bind('pony-data', app.ports.messages.send)
	
	console.log('Connected!')
}))
