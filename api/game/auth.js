module.exports = ({ findUser }) => (req, res, next) => {
	const user = JSON.parse(req.cookies.user)
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