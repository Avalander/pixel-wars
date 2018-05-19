const makeGameApi = require('./api')
const makeGameState = require('./state')
const {
	makeFindUser,
	makeRegisterUser,
	makeIncreaseCellCount,
} = require('./store')
const makeAuth = require('./auth')

module.exports = ({ Router, db, pusher }) => {
	const findUser = makeFindUser({ db })

	return makeGameApi({
		Router,
		pusher,
		makeGameState,
		registerUser: makeRegisterUser({ db }),
		increaseCellCount: makeIncreaseCellCount({ db }),
		auth: makeAuth({ findUser }),
	})
}