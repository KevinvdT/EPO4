const WebSocket = require("ws");

const types = {
  MATLAB: "MATLAB",
  BROWSER: "BROWSER",
};

const noop = () => {};

const heartbeat = function () {
  this.isAlive = true;
};

const server = new WebSocket.Server({ port: 8080 });

console.log("Websocket server started");

// Message received from client
const onMessage = (rawData, ws) => {
  let data = null;
  try {
    data = JSON.parse(rawData);
  } catch (error) {
    console.log(
      "Error decoding data as JSON, sending raw string instead",
      error
    );
    data = rawData;
  }
  // console.log(data);

  if (
    typeof data !== "undefined" &&
    typeof data.type !== "undefined" &&
    typeof ws.type === "undefined"
  ) {
    ws.type = data.type;
    console.log("New connection: " + data.type);
  } else {
    let receiveType = null;
    if (ws.type === types.MATLAB) receiveType = types.BROWSER;
    else if (ws.type === types.BROWSER) receiveType = types.MATLAB;
    else receiveType = "unknown";

    server.clients.forEach((ws) => {
      if (ws.type === receiveType) {
        ws.send(rawData);
        if (receiveType === "MATLAB") console.log(rawData);
      }
    });
  }
};

// Setup of client connection
server.on("connection", function connection(ws, request) {
  ws.on("message", (data) => onMessage(data, ws));
  ws.isAlive = true;
  // ws.id = crypto.randomBytes(16).toString('hex');
  ws.on("pong", heartbeat);
});

// Check if clients are still connected (heartbeats)
const interval = setInterval(function ping() {
  server.clients.forEach(function each(ws) {
    if (ws.isAlive === false) return ws.terminate();
    ws.isAlive = false;
    ws.ping(noop);
  });
}, 10000);

// Close heartbeat interval when closing server
server.on("close", function close() {
  clearInterval(interval);
});
