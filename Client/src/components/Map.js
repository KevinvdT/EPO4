import React, { Component } from "react";
import styled from "styled-components";

import { maprange } from "../utils";

const Container = styled.div`
  display: flex;
  flex-direction: column;
  grid-area: map;
  text-align: center;
  padding: 2rem;
`;

const Svg = styled.svg`
  height: 100%;
  width: auto;
`;

const Car = function (props) {
  const carWidth = 40.649;
  const carHeight = 66.8741;
  const { x: xPosition, y: yPosition, theta } = props.position;
  const xPixels = maprange(xPosition, [0, 600], [0, 660]) - carWidth / 2;
  const yPixels = maprange(yPosition, [600, 0], [0, 660]) - carHeight / 2;
  return (
    <rect
      x={xPixels}
      y={yPixels}
      width={carWidth}
      height={carHeight}
      transform={`rotate(${theta} ${xPixels + carWidth / 2} ${
        yPixels + carHeight / 2
      })`}
      rx={12}
      fill="#00FAB0"
    />
  );
};

const Waypoints = function (props) {
  const locations = props.locations || [];
  // window.locations = locations;
  // const x = 300;
  // const y = 100;
  // console.log(locations);
  // return null;
  const [xPosition, yPosition] = locations;
  const xPixels = maprange(xPosition, [0, 600], [0, 660]) + 8; // +8 to get to the actual center of the icon
  const yPixels = maprange(yPosition, [600, 0], [0, 660]); // - carHeight / 2;
  return (
    <path
      key={`${xPixels},${yPixels}`}
      d={`M${xPixels},${yPixels}l11.269,11.268l-4.062,4.062l-11.268,-11.268l-11.269,11.268l-4.062,-4.062l11.269,-11.268l-11.269,-11.268l4.062,-4.062l11.269,11.268l11.268,-11.268l4.062,4.062l-11.269,11.268z`}
      fill="#FF5353"
    />
  );

  // const waypointSvgElements = locations.map((x, y) => (
  //   <path
  //     key={`${x},${y}`}
  //     d={`M${x},${y}l11.269,11.268l-4.062,4.062l-11.268,-11.268l-11.269,11.268l-4.062,-4.062l11.269,-11.268l-11.269,-11.268l4.062,-4.062l11.269,11.268l11.268,-11.268l4.062,4.062l-11.269,11.268z`}
  //     fill="#FF5353"
  //   />
  //   // <p></p>
  // ));

  // return <React.Fragment>{waypointSvgElements}</React.Fragment>;
};

export default class Map extends Component {
  render() {
    const { car } = this.props;

    return (
      <Container>
        <Svg
          viewBox="0 0 661 661"
          fill="none"
          xmlns="http://www.w3.org/2000/svg"
        >
          <rect
            x="0.500031"
            y="0.649658"
            width={660}
            height={660}
            fill="#4F4F4F"
          />
          <circle cx="25.5" cy="637.354" r="12.5" fill="white" />
          <circle cx="330.5" cy="637.354" r="12.5" fill="white" />
          <circle cx="635.5" cy="637.354" r="12.5" fill="white" />
          <circle cx="635.5" cy="27.1746" r="12.5" fill="white" />
          <circle cx="25.5" cy="27.1746" r="12.5" fill="white" />

          {/* The car BEGIN */}
          <Car position={car.position} />
          {/* The car END */}
          {/* <rect
            x="41.2487"
            y="593.836"
            width="66.8741"
            height="40.649"
            rx={12}
            transform="rotate(90.0855 41.2487 593.836)"
            fill="#00FAB0"
          />
          <rect
            x="660.5"
            y="0.649658"
            width="66.8741"
            height="40.649"
            rx={12}
            transform="rotate(90.0855 660.5 0.649658)"
            fill="#00FAB0"
          /> */}
          <Waypoints locations={car.waypoints} />
        </Svg>
      </Container>
    );
  }
}
