module.exports = ({ Router, makeGameState, registerUser, auth }) => {
	const api = Router()
	const board = makeGameState()

	api.get('/board', (req, res) => res.json(board))

	api.post('/register', (req, res, next) =>
		registerUser(req.body.username)
			.fork(
				next,
				({ username, count }) =>
					res.cookie('user', JSON.stringify({ username, count }), { httpOnly: true })
						.json({ username: `${username} #${count}`, board })
			)
	)

	return api
}