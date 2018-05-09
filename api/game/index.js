const makeGameApi = require('./api')
const makeGameState = require('./state')
const {
	makeFindUser,
	makeRegisterUser,
} = require('./store')
const makeAuth = require('./auth')

module.exports = ({ Router, db, pusher }) => {
	const findUser = makeFindUser({ db })

	return makeGameApi({
		Router,
		pusher,
		makeGameState,
		registerUser: makeRegisterUser({ db }),
		auth: makeAuth({ findUser }),
	})
}