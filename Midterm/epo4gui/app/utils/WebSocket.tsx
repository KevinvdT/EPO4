import React, { Component, Fragment } from 'react';
import connect from 'react-redux';

import { addWebsocketToStore, onMessageReceived } from '../actions/websocket';

class WebSocket extends Component {
  componentDidMount() {
    const ws = new WebSocket('ws://localhost:30000');
    ws.onopen = () => {
      console.log('Connected to websockets server');
      this.props.addWebsocketToStore(ws);
    };
    ws.onmessage = event => {
      this.props.onMessageReceived(event);
    };
  }
  render() {
    return <Fragment>{this.props.children}</Fragment>;
  }
}

function mapStateToProps(state) {
  return {
    ws: state.ws
  };
}

export default connect(mapStateToProps, {
  addWebsocketToStore,
  onMessageReceived
})(WebSocket);
