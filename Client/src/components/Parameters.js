import React, { Component } from "react";

import Tile from "./Tile";

export default class Parameters extends Component {
  state = {
    newStartPointX: null,
    newStartPointY: null,
    newStartPointTheta: null,
    newFinalPointX: null,
    newFinalPointY: null,
  };

  handleChange = (event) => {
    this.setState({ [event.target.name]: event.target.value });
  };

  handleSubmit = (event) => {
    event.preventDefault();
    // TODO: prevent need for parseInt() in creation of messageObject,
    //       by doing this in this.handleChange() ?
    // Getting inputted parameters from state
    const {
      newStartPointX,
      newStartPointY,
      newStartPointTheta,
      newFinalPointX,
      newFinalPointY,
    } = this.state;

    // Message to sent to Matlab
    const messageObject = {
      command: "SET_PARAMETERS",
      payload: {
        startPoint: {
          x: parseInt(newStartPointX),
          y: parseInt(newStartPointY),
          theta: parseInt(newStartPointTheta),
        },
        finalPoint: {
          x: parseInt(newFinalPointX),
          y: parseInt(newFinalPointY),
        },
      },
    };

    // Sending message to Matlab
    const messageString = JSON.stringify(messageObject);
    this.props.socket.send(messageString);
  };

  render() {
    return (
      <Tile areaName="parameters" title="Parameters">
        <form onSubmit={this.handleSubmit}>
          <label>
            Start point x:
            <input
              type="number"
              name="newStartPointX"
              onChange={this.handleChange}
            />
            cm
          </label>
          <br />
          <label>
            Start point y:
            <input
              type="number"
              name="newStartPointY"
              onChange={this.handleChange}
            />
            cm
          </label>
          <br />
          <label>
            Start point θ:
            <input
              type="number"
              name="newStartPointTheta"
              onChange={this.handleChange}
            />
            deg
          </label>
          <br />
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
