import React, { Component, Fragment } from 'react';
import AppContainer from '../AppContainer';
export default class WebSocket extends Component {
  state = {
    ws: null,
    carState: {
      position: 10
    }
  };

  componentDidMount() {
    const ws = new WebSocket('ws://localhost:30000');
    ws.onopen = () => {
      console.log('Connected to websockets server');
      this.setState({ ws });
    };
    ws.onmessage = event => {
      const rawMessage = event.value;
      const message = JSON.parse(rawMessage);
      this.setState({ carState: message });
    };
  }
  render() {
    return (
      <Fragment>
        <AppContainer carState={this.state.carState} />
      </Fragment>
    );
  }
}
