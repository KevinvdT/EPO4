import React, { Component } from "react";
import styled from "styled-components";

import Tile from "./Tile";
import Map from "./Map";
import Settings from "./Settings";

const Container = styled.div`
  display: flex;
  flex-direction: row;
  justify-content: center;
  width: 100vw;
`;
const Grid = styled.div`
  box-sizing: border-box;
  display: grid;
  grid-template-columns: 1fr 1fr 1fr 1fr;
  grid-template-rows: 30px 6fr 2fr;
  gap: 20px 20px;
  padding: 20px;
  height: 100vh;
  width: 100vw;
  max-width: 1200px;
  grid-template-areas: "top top top top" "parameters map map map" "parameters bottom1 bottom2 bottom3";
  & * {
    /* border: 1px solid red; */
  }
`;

const Top = styled.div`
  grid-area: top;
  text-align: center;
`;

export default class Page extends Component {
  state = {
    socket: null,
    car: {
      position: {
        x: 302,
        y: 200,
        theta: 20,
      },
      speed: 5,
      acceleration: 22,
    },
  };

  componentDidMount() {
    this.websocketInit();
  }

  websocketInit = () => {
    const socket = new WebSocket("ws://localhost:8080");

    socket.addEventListener("open", (event) => {
      console.log("Connected to websockets server");
      // Identify as browser (not Matlab) to the server
      socket.send(
        JSON.stringify({
          type: "BROWSER",
        })
      );
    });

    socket.addEventListener("message", (event) => {
      const data = JSON.parse(event.data);
      // Update the received car state in the GUI
      if (data.car) this.setState({ car: data.car });
    });
  };

  render() {
    const { position, speed, acceleration } = this.state.car;

    return (
      <Container>
        <Grid>
          <Top>TU Delft · Electrical Engineering · EPO 4 Group A12</Top>
          <Tile areaName="parameters" title="Parameters">
            Parameters
          </Tile>
          <Map car={this.state.car} />
          <Tile areaName="bottom1" title="Position">
            x = {position.x} cm
            <br />y = {position.y} cm
            <br />θ = {position.theta} deg
          </Tile>
          <Tile areaName="bottom2" title="Speed">
            {speed} m/s
          </Tile>
          <Tile areaName="bottom3" title="Acceleration">
            {acceleration} m/s<sup>2</sup>
          </Tile>
        </Grid>
        <Settings />
      </Container>
    );
  }
}
