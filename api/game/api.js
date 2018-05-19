module.exports = ({ Router, pusher, makeGameState, registerUser, auth }) => {
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

		const boardCell = board.cells.find(({ x, y }) => x == cell.x && y == cell.y)
		boardCell.owner = user
		res.json({ board })

		pusher.trigger('game-updates', 'update-cell', boardCell)
	})

	return api
}