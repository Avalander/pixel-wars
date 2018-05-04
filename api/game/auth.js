module.exports = ({ findUser }) => (req, res, next) => {
	const { user } = req.cookies
	if (!user) return next(new Error('User not found.'))
	findUser(user)
		.fork(
			error => next(error),
			user => {
				req.user = user
				next()
			}
		)
}