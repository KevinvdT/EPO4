import React, { Component, Fragment } from 'react';

export default class WebSocket extends Component {
  componentDidMount() {
    const ws = new WebSocket('ws://localhost:30000');
    ws.onopen = () => {
      console.log('Connected to websockets server');
    };
    ws.onmessage = event => {
      const message = JSON.parse(event.data);
      this.setState;
    };
  }
  render() {
    return <Fragment>{this.props.children}</Fragment>;
  }
}
