const path = require('path')

const webpack = require('webpack')
const HtmlWebpackPlugin = require('html-webpack-plugin')

require('dotenv').config()

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
				},
			}
		}, {
			test: /\.elm$/,
			exclude: [
				'elm-stuff',
				'node_modules',
			],
			use: [{
				loader: 'elm-webpack-loader',
				options: {
					verbose: true,
					warn: true,
				}
			}]
		}]
	},
	plugins: [
		new HtmlWebpackPlugin({
			template: path.join(folders.src, 'index.html'),
			filename: 'index.html',
			chunks: [ 'main' ],
		}),
		new webpack.DefinePlugin({
			PUSHER_KEY: JSON.stringify(process.env.PUSHER_KEY),
		})
	],
	resolve: {
		modules: [
			folders.src,
			folders.shared,
			'node_modules',
		]
	},
})