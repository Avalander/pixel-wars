const makeGameApi = require('./api')
const makeGameState = require('./state')
const {
	makeFindUser,
	makeRegisterUser,
} = require('./store')
const makeAuth = require('./auth')

module.exports = ({ Router, db }) => {
	const findUser = makeFindUser({ db })

	return makeGameApi({
		Router,
		makeGameState,
		registerUser: makeRegisterUser({ db }),
		auth: makeAuth({ findUser }),
	})
}