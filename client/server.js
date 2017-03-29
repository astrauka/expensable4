// Webpack server running on http://localhost:4000

var webpack = require('webpack');
var WebpackDevServer = require('webpack-dev-server');
var jade = require('jade');
var config = require('./webpack.client.hot.config');

var server = new WebpackDevServer(webpack(config), {
  publicPath: config.output.publicPath,
  hot: true,
  historyApiFallback: true,
  stats: {
    colors: true,
    hash: false,
    version: false,
    chunks: false,
    children: false,
  },
});

var initialState = '';

server.app.use('/', function(req, res) {
  var locals = {
    props: JSON.stringify(initialState),
  };
  var layout = process.cwd() + '/index.jade';
  var html = jade.compileFile(layout, { pretty: true })(locals);
  res.send(html);
});

server.listen(4000, 'localhost', function(err) {
  if (err) console.log(err);
  console.log('Listening at localhost:4000...');
});
