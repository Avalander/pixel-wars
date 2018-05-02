const webpack = require('webpack')
const merge = require('webpack-merge')
const common_config = require('./common')

module.exports = ({ base_dir, folders }) => merge(common_config({ base_dir, folders }), {
	module: {
		rules: [{
			test: /\.scss/,
			use: [ 'style-loader', 'css-loader', {
				loader: 'sass-loader',
				options: {
					includePaths: [ folders.src ]
				}
			}]
		}]
	},
	plugins: [
		new webpack.HotModuleReplacementPlugin(),
		new webpack.NamedModulesPlugin(),
		new webpack.SourceMapDevToolPlugin(),
	],
	devServer: {
		contentBase: folders.dist,
		compress: true,
		hot: true,
		stats: 'minimal',
		historyApiFallback: {
			index: '/index.html',
		},
		proxy: {
			'/api': 'http://localhost:3008',
		},
	},
})