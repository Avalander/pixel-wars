const Future = require('fluture')


module.exports.makeRegisterUser = ({ db }) => username =>
	Future.node(done =>
		db.collection('users')
			.count({ username }, done)
	)
	.map(count => ({ username, count, color: randomColor() }))
	.chain(user =>
		Future.both(
			Future.of(user),
			saveUser(db, user)
		)
	)
	.map(([ user, _ ]) => user)

module.exports.makeFindUser = ({ db }) => ({ username, count }) =>
	findUser(db, username, count)
		.chain(user => user
			? Future.of(user)
			: Future.reject('User not found.')
		)
		.chain(user => user.count >= count
			? Future.of(user)
			: Future.reject('User not found.')
		)

module.exports.makeIncreaseCellCount = ({ db }) => ({ username, count }) =>
		findUser(db, username, count)
			.chain(user => user
				? Future.of(user)
				: Future.reject('User not found.')
			)
			.map(user => Object.assign({}, user, {
				claimed_cells: (user.claimed_cells || 0) + 1
			}))
			.chain(user =>
				Future.both(
					Future.of(user),
					saveUser(db, user)
				)
			)
			.map(([ user, _ ]) => user)

const findUser = (db, username, count) =>
	Future.node(done =>
		db.collection('users')
			.findOne({ username, count }, done)
	)

const saveUser = (db, user) =>
	Future.node(done =>
		db.collection('users')
			.save(user, null, done)
	)

const randomColor = () => {
	const result = []
	for (let i=0; i<6; i++) {
		result.push(choose('0123456789abcdef'))
	}
	return result.join('')
}

const choose = options =>
	options[Math.floor(Math.random() * options.length)]