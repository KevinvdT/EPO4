import React, { Component } from 'react';

export default class AppContainer extends Component {
  render() {
    const { carState } = this.props;
    return <div>Car position: {carState.position}</div>;
  }
}
