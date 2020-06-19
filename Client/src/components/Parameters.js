import React, { Component } from "react";
import styled, { css } from "styled-components";

import Tile from "./Tile";

const InputField = styled.input`
  background: none;
  color: white;
  font-family: "Nunito Sans", sans-serif;
  padding: 0.2rem;
  border: none;
  border-bottom: 2px solid #9c9c9c;
  width: 4rem;
  margin: 0.2rem 0.2rem 0.2rem 1rem;
  text-align: center;
`;

const ButtonStyle = css`
  color: white;
  background: #868686;
  border: none;
  padding: 0.5rem 1.8rem;
  font-family: "Nunito Sans", sans-serif;
  font-weight: bold;
  margin: 1rem 0;
  display: block;
  width: 100%;
`;

const InputButton = styled.input`
  ${ButtonStyle}
`;

const ButtonButton = styled.button`
  ${ButtonStyle}
`;

const ResetButton = styled.button`
  ${ButtonStyle}
  color: white;
  background: #ff5353;
`;

// const

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

  sendKittInit = () => {
    this.props.socket.send(
      JSON.stringify({
        command: "INITIALIZE_KITT",
      })
    );
  };

  sendKittStart = () => {
    this.props.socket.send(
      JSON.stringify({
        command: "START_KITT",
      })
    );
  };

  sendRestartMatlab = () => {
    this.props.socket.send(
      JSON.stringify({
        command: "RESTART_MATLAB",
      })
    );
  };

  sendStartVoiceCommand = () => {
    this.props.socket.send(
      JSON.stringify({
        command: "VOICE_COMMAND",
      })
    );
  };

  render() {
    return (
      <Tile areaName="parameters" title="Parameters">
        <span style={{ textAlign: "left" }}>
          <form onSubmit={this.handleSubmit}>
            <label>
              Start point x:
              <InputField
                type="number"
                name="newStartPointX"
                onChange={this.handleChange}
              />
              cm
            </label>
            <br />
            <label>
              Start point y:
              <InputField
                type="number"
                name="newStartPointY"
                onChange={this.handleChange}
              />
              cm
            </label>
            <br />
            <label>
              Start point θ:
              <InputField
                type="number"
                name="newStartPointTheta"
                onChange={this.handleChange}
              />
              deg
            </label>
            <br />
            <label>
              Final point x:
              <InputField
                type="number"
                name="newFinalPointX"
                onChange={this.handleChange}
              />
              cm
            </label>
            <br />
            <label>
              Final point y:
              <InputField
                type="number"
                name="newFinalPointY"
                onChange={this.handleChange}
              />
              cm
            </label>
            <br />
            <InputButton type="submit" value="Submit" />
          </form>

          {/* <ButtonButton onClick={this.sendKittInit}>Init</ButtonButton> */}

          <ButtonButton onClick={this.sendStartVoiceCommand}>
            Voice Command
          </ButtonButton>
          <ResetButton onClick={this.sendKittStart}>Manual Start</ResetButton>
          <ResetButton onClick={this.sendRestartMatlab}>
            Restart Matlab
          </ResetButton>
        </span>
      </Tile>
    );
  }
}
