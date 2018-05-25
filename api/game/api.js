module.exports = ({ Router, pusher, makeGameState, registerUser, increaseCellCount, auth }) => {
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
		increaseCellCount(user)
			.fork(
				err => res.status(500).send(err),
				user => {
					res.json({ board })
					pusher.trigger('game-updates', 'update-cell', boardCell)
					pusher.trigger('game-updates', 'update-leaderboard', makeLeaderboard(board.cells))
				}
			)
	})

	return api
}

const makeLeaderboard = cells => {
	const result = Object.entries(countCellsOwned(cells))
	result.sort((a, b) => b[1].amount - a[1].amount)
	return result.slice(0, 10)
		.map(([ _, { amount, user }]) => ({ user, amount }))
		.map(({ amount, user: { username, count, color }}) => ({
			amount,
			user: {
				username, count, color
			}
		}))
}

const countCellsOwned = cells =>
	cells.reduce((prev, { owner }) =>
		owner
			? Object.assign({}, prev, {
				[ownerToUsername(owner)]: {
					amount: getPreviousAmount(prev, owner) + 1,
					user: owner,
				}
			})
			: prev,
		{}
	)

const getPreviousAmount = (prev, owner) =>
	(prev[ownerToUsername(owner)]
		? prev[ownerToUsername(owner)].amount
		: 0
	)

const ownerToUsername = ({ username, count }) => `${username} #${count}`
