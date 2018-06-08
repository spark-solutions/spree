var path = require('path');
var webpack = require('webpack');

module.exports = {
  entry: './javascript/src/main.js',
  output: {
    path: path.resolve(__dirname, 'javascript', 'dist'),
    filename: 'main.js'
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        loader: 'babel-loader'
      }
    ]
  },
  stats: {
    colors: true
  }
};
