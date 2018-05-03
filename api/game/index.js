const makeGameApi = require('./api')
const makeGameState = require('./state')

module.exports = ({ Router }) => makeGameApi({
	Router,
	makeGameState,
})