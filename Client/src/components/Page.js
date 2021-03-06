import React, { Component } from "react";
import styled from "styled-components";

import Tile from "./Tile";
import Map from "./Map";
// import Settings from "./Settings";
import Parameters from "./Parameters";

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

const NumberLarge = styled.span`
  font-size: 3em;
  font-weight: bold;
`;

const UnitLarge = styled.span`
  font-size: 1.6em;
  font-weight: bold;
  letter-spacing: 1.2px;
`;

export default class Page extends Component {
  state = {
    socket: null,
    car: {
      position: {
        x: -999,
        y: -999,
        theta: 0,
      },
      speed: 0,
      acceleration: 0,
    },
    settingsOpen: false,
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

    this.setState({ socket });
  };

  openSettings = () => {
    this.setState({ settingsOpen: true });
  };

  closeSettings = () => {
    this.setState({ settingsOpen: false });
  };

  render() {
    const { position, speed } = this.state.car;
    let timer = this.state.car.timer || 0;
    const timerSeconds = Math.floor(timer % 60);
    const timerMinutes = Math.floor(timer / 60);
    const { socket } = this.state;

    return (
      <Container>
        <Grid>
          <Top>TU Delft · Electrical Engineering · EPO 4 Group A12</Top>
          <Parameters socket={socket} />
          <Map car={this.state.car} />
          <Tile areaName="bottom1" title="Position">
            x = {Math.round(position.x)} cm
            <br />y = {Math.round(position.y)} cm
            <br />θ = {Math.round(position.theta)} deg
          </Tile>
          <Tile areaName="bottom2" title="Speed">
            <NumberLarge>{Math.round(speed)}</NumberLarge>
            <UnitLarge> cm/s</UnitLarge>
          </Tile>
          <Tile areaName="bottom3" title="Timer">
            {timerMinutes ? (
              <React.Fragment>
                <NumberLarge>{timerMinutes}</NumberLarge>
                <UnitLarge> min </UnitLarge>
              </React.Fragment>
            ) : null}
            <NumberLarge>{timerSeconds}</NumberLarge>
            <UnitLarge> sec</UnitLarge>
          </Tile>
        </Grid>
        {/* <Settings isOpen={settingsOpen} closeSettings={this.closeSettings} /> */}
      </Container>
    );
  }
}
