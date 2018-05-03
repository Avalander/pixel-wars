module.exports = () => {
	const board = createBoard(10, 10)

	return board
}

const createBoard = (width, height) => {
	const result = []
	for (let y = 0; y < height; y++) {
		for (let x = 0; x < width; x++) {
			result.push({
				x, y,
			})
		}
	}
	return result
}