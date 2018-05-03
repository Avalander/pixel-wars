module.exports = ({ Router, makeGameState }) => {
	const api = Router()
	const board = makeGameState()

	api.get('/board', (req, res) => res.json(board))

	return api
}