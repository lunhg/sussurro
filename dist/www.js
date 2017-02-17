var app, chalk, debug, http, normalizePort, port, server;

app = require('../dist/build');

debug = require('debug')('sussurro:server');

http = require('http');

chalk = require('chalk');


/* Get port from environment and store in Express */

normalizePort = function(val) {
  var port;
  port = parseInt(val, 10);
  if (isNaN(port)) {
    return val;
  }
  if (port >= 0) {
    return port;
  }
  return false;
};

port = normalizePort(process.env.PORT || '3000');

app.set('port', port);


/* Create HTTP server */

server = http.createServer(app);


/* Listen on provided port, on all network interfaces */

server.on('error', function(error) {
  var bind, fn;
  if (error.syscall !== 'listen') {
    throw error;
  }
  bind = typeof port === 'string' ? 'Pipe ' + port : 'Port ' + port;
  fn = function(msg) {
    console.error(bind + ' ' + msg);
    return process.exit(1);
  };
  if (error.code === 'EACCES') {
    return fn('requires elevated privileges');
  } else if (error.code === 'EADDRINUSE') {
    return fn('is already in use');
  } else {
    throw error;
  }
});

server.on('listening', function() {
  var addr, bind;
  addr = server.address();
  bind = typeof addr === 'string' ? 'pipe ' + addr : 'port ' + addr.port;
  return debug(chalk.green('Listening sussurro server in ' + bind));
});

server.listen(port);
