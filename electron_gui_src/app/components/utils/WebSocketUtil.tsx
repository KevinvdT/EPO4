import React, { Component, Fragment } from 'react';
import AppContainer from '../AppContainer';
export default class WebSocketUtil extends Component {
  state = {
    socket: null,
    carState: {
      position: 0
    }
  };

  componentDidMount() {
    const socket = new WebSocket('ws://localhost:30000');
    window.socket = socket;
    socket.addEventListener('open', event => {
      console.log('Connected to websockets server');
      this.setState({ socket });
    });
    socket.addEventListener('message', event => {
      const rawMessage = event.data;
      window.rm = rawMessage;
      const message = JSON.parse(rawMessage);
      this.setState({ carState: message });
    });
    document.addEventListener(
      'keydown',
      event => {
        if (event.keyCode === 32) {
          const data = { type: 'voiceCommand' };
          const message = JSON.stringify(data);
          socket.send(message);
        }
      },
      false
    );
  }
  render() {
    return (
      <Fragment>
        <AppContainer carState={this.state.carState} />
      </Fragment>
    );
  }
}
