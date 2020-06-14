import React from "react";
import styled from "styled-components";

const Container = styled.div`
  display: flex;
  flex-direction: column;
  align-items: stretch;
  background: #3c3c3c;
  /* height: 50vh; */
  grid-area: ${(props) => props.areaName};
`;

const Header = styled.div`
  text-align: center;
  background: #4f4f4f;
  /* height: 3.1rem; */
  flex: 0 0 2.8rem;
  display: flex;
  flex-direction: column;
  justify-content: center;
`;

const Body = styled.div`
  flex: 1 0 auto;
  text-align: center;
  padding: 0.5rem;
`;

export default function Tile(props) {
  return (
    <Container areaName={props.areaName}>
      <Header>{props.title}</Header>
      <Body>{props.children}</Body>
    </Container>
  );
}
