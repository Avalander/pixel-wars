const path = require('path')

const express = require('express')
const bodyParser = require('body-parser')

const makeDatabase = require('database')
const initPusher = require('init-pusher')

require('dotenv').config()


const {
	DB_URL,
	DB_NAME,
	PORT,
	PUSHER_APP_ID,
	PUSHER_KEY,
	PUSHER_SECRET,
	PUSHER_CLUSTER,
} = process.env

const pusher = initPusher({ PUSHER_APP_ID, PUSHER_KEY, PUSHER_SECRET, PUSHER_CLUSTER })

const app = express()
app.disable('x-powered-by')
app.use(bodyParser.json())

const database = makeDatabase({ DB_URL, DB_NAME })
database()
	.then(db => {
		const static_root = path.join(__dirname, '..', 'static')
		app.use(express.static(static_root, { extensions: [ 'html' ]}))
		app.listen(PORT, () => `Server started on port ${PORT}.`)
	})
	.catch(err => {
		console.error(err)
		process.exit(1)
	})

const exitHandler = () =>
	database.close()
		.then(() => {
			console.log('Bye.')
			process.exit()
		})

process.on('exit', exitHandler)
process.on('SIGINT', exitHandler)
process.on('SIGTERM', exitHandler)
