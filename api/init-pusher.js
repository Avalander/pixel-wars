const Pusher = require('pusher')

module.exports = ({ PUSHER_APP_ID, PUSHER_KEY, PUSHER_SECRET, PUSHER_CLUSTER }) =>
	new Pusher({
		appId: PUSHER_APP_ID,
		key: PUSHER_KEY,
		secret: PUSHER_SECRET,
		cluster: PUSHER_CLUSTER,
		encrypted: true,
	})
