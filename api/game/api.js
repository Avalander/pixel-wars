module.exports = ({ Router, makeGameState, registerUser, auth }) => {
	const api = Router()
	const board = makeGameState()

	api.post('/register', (req, res, next) =>
		registerUser(req.body.username)
			.fork(
				next,
				({ username, count, color }) =>
					res.cookie('user', JSON.stringify({ username, count, color }), { httpOnly: true })
						.json({ user: { username, count, color }, board })
			)
	)

	api.post('/claim', auth, (req, res) => {
		const user = req.user
		const cell = req.body

		const boardCell = board.find(({ x, y }) => x == cell.x && y == cell.y)
		boardCell.color = '#' + user.color
		res.json({ board })
	})

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