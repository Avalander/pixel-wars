const mongodb = require('mongodb')

module.exports = ({ DB_URL, DB_NAME }) => {
	const connection = mongodb.MongoClient.connect(DB_URL)
	const getDb = () => connection.then(client => client.db(DB_NAME))
	getDb.close = () => connection.then(client => client.close())
	return getDb
}
