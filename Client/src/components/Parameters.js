import React, { Component } from "react";

import Tile from "./Tile";

export default class Parameters extends Component {
  state = {
    newFinalPointX: null,
    newFinalPointY: null,
  };

  handleChange = (event) => {
    this.setState({ [event.target.name]: event.target.value });
  };

  handleSubmit = (event) => {
    event.preventDefault();
    const { newFinalPointX, newFinalPointY } = this.state;
    const messageObject = {
      command: "SET_FINAL_POINT",
      payload: {
        x: parseInt(newFinalPointX),
        y: parseInt(newFinalPointY),
      },
    };
    const messageString = JSON.stringify(messageObject);
    this.props.socket.send(messageString);
  };

  render() {
    return (
      <Tile areaName="parameters" title="Parameters">
        <form onSubmit={this.handleSubmit}>
          <label>
            Final point x:
            <input
              type="number"
              name="newFinalPointX"
              onChange={this.handleChange}
            />
            cm
          </label>
          <br />
          <label>
            Final point y:
            <input
              type="number"
              name="newFinalPointY"
              onChange={this.handleChange}
            />
            cm
          </label>
          <br />
          <input type="submit" value="Submit" />
        </form>
      </Tile>
    );
  }
}
