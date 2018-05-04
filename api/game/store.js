const Future = require('fluture')


module.exports.makeRegisterUser = ({ db }) => username =>
	Future.node(done =>
		db.collection('users')
			.findOne({ username }, done)
	)
	.map(userOrCreate(username))
	.map(incrementCount)
	.chain(user =>
		Future.both(
			Future.of(user),
			saveUser(db, user)
		)
	)
	.map(([ user, _ ]) => user)

module.exports.makeFindUser = ({ db }) => ({ username, count }) =>
	findUser(db, username)
		.chain(user => user
			? Future.of(user)
			: Future.reject('User not found.')
		)
		.chain(user => user.count >= count
			? Future.of(user)
			: Future.reject('User not found.')
		)


const findUser = (db, username) =>
	Future.node(done =>
		db.collection('users')
			.findOne({ username }, done)
	)

const userOrCreate = username => user =>
	(user != null
		? user
		: ({ username, count: 0 })
	)

const incrementCount = user =>
	Object.assign({}, user, { count: user.count + 1 })

const saveUser = (db, user) =>
	Future.node(done =>
		db.collection('users')
			.save(user, null, done)
	)