const path = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')

module.exports = ({ base_dir, folders }) => ({
	entry: {
		main: path.resolve(folders.src, 'index.js'),
	},
	output: {
		path: folders.dist,
		filename: '[name].bundle.js',
	},
	module: {
		rules: [{
			test: /\.js/,
			exclude: /node_modules/,
			use: {
				loader: 'babel-loader',
				options: {
					presets: [[ 'env', {
						targets: {
							browsers: [ 'last 2 versions' ],
						}
					}]],
					/*
					plugins: [
						['transform-object-rest-spread', { useBuiltIns: true }]
					],
					*/
				},
			}
		}]
	},
	plugins: [
		new HtmlWebpackPlugin({
			template: path.join(folders.src, 'index.html'),
			filename: 'index.html',
			chunks: [ 'main' ],
		}),
		/*
		new HtmlWebpackPlugin({
			template: path.join(folders.src, 'login.html'),
			filename: 'login.html',
			chunks: [ 'login' ],
		}),
		*/
	],
	resolve: {
		modules: [
			folders.src,
			folders.shared,
			'node_modules',
		]
	},
})