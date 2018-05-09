module.exports = ({ Router, makeGameState, registerUser, auth }) => {
	const api = Router()
	const board = makeGameState()

	api.get('/board', (req, res) => res.json(board))

	api.post('/register', (req, res, next) =>
		registerUser(req.body.username)
			.fork(
				next,
				({ username, count, color }) =>
					res.cookie('user', JSON.stringify({ username, count }), { httpOnly: true })
						.json({ user: { username, count, color }, board })
			)
	)

	/*
	const state$ = xs.create({
		start: listener => {
			api.post('/claim', auth, (req, res) => {
				listener.next({ type: 'claim', user: req.user, cell: req.body.cell })
				res.json({ ok: true })
			})
		},
		stop: () => {},
	})
	.fold((prev, { user, cell }) => {

	}, board)
	*/

	return api
}