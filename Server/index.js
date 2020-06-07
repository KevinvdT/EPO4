const WebSocket = require('ws');

const types = {
  MATLAB: 'MATLAB',
  BROWSER: 'BROWSER',
};
const noop = () => {};

const heartbeat = function () {
  this.isAlive = true;
};

const server = new WebSocket.Server({ port: 8080 });

server.on('connection', function connection(ws) {
  ws.on('message', function incoming(data) {
    console.log('hi');
    console.log(data);
    ws.send('hello back');
  });

  ws.isAlive = true;
  // TODO: Set type to types.MATLAB or types.BROWSER
  ws.type = null;
  ws.on('pong', heartbeat);
});

// Check if clients are still connected
const interval = setInterval(function ping() {
  console.log(server.clients.forEach((ws) => ws.address));
  server.clients.forEach(function each(ws) {
    if (ws.isAlive === false) return ws.terminate();
    ws.send('hello from node');
    ws.isAlive = false;

    ws.ping(noop);
  });
}, 10000);

server.on('close', function close() {
  clearInterval(interval);
});
