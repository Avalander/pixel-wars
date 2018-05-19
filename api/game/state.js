module.exports = () => {
	const board = createBoard(25, 25)

	return {
		width: 25,
		height: 25,
		cells: board,
	}
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