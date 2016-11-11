const webpack = require('webpack');
const conf = require('./gulp.conf');
const path = require('path');

const HtmlWebpackPlugin = require('html-webpack-plugin');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const autoprefixer = require('autoprefixer');

module.exports = {
  module: {
    loaders: [
      {
        test: /.json$/,
        loaders: [
          'json'
        ]
      },
      {
        test: /\.css$/,
        loaders: ExtractTextPlugin.extract({
          loader: 'css'
        })
      },
      {
        test: /\.tsx?$/,
        exclude: /node_modules/,
        loaders: ['ts']
      },
      {
        test: /\.(png|woff|woff2|eot|ttf|svg)$/,
        loader: 'file'
      }
    ]
  },
  debug: true,
  devtool: 'source-map',
  plugins: [
    new HtmlWebpackPlugin({
      template: conf.path.src('index.html'),
      inject: true
    }),
    new ExtractTextPlugin('index-[contenthash].css')
  ],
  output: {
    path: path.join(process.cwd(), conf.paths.build),
    filename: 'index.js'
  },
  resolve: {
    extensions: [
      '',
      '.webpack.js',
      '.web.js',
      '.js',
      '.ts',
      '.tsx'
    ]
  },
  entry: [
    `./${conf.path.src('index')}`
  ],
  ts: {
    configFileName: 'tsconfig.json'
  },
  tslint: {
    configuration: require('../tslint.json')
  }
};
