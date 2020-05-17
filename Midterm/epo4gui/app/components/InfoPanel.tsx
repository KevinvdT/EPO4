import React, { Component } from 'react';
import styled from 'styled-components';

const Container = styled.div`
  flex: 0 0 auto;
  flex-direction: column;
  width: 16rem;
  display: flex;
`;

const Block = styled.div`
  flex-direction: column;
  flex: 1 0 auto;
  background: #ffe8c0;
  box-shadow: 0px 10px 0px #c19f67;
  border-radius: 12px;
  margin: 1rem;
  padding: 1rem;
  color: #423114;
`;

const BlockTitle = styled.div`
  height: 2rem;
  flex: 0 0 auto;
`;

const BlockBody = styled.div`
  flex: 1 1 auto;
  text-align: center;
`;

const Digits = styled.span`
  font-family: 'Roboto Mono';
  font-size: 3em;
`;

export default class InfoPanel extends Component {
  render() {
    const { position, velocity, acceleration } = this.props.carState;
    const distance = 600 - position;
    const distanceRounded = Math.round(distance);
    const velocityRounded = Math.round(velocity);
    const accelerationRounded = Math.round(acceleration * 100) / 100;
    return (
      <Container>
        <Block>
          <BlockTitle>Timer</BlockTitle>
        </Block>
        <Block>
          <BlockTitle>Voice Command</BlockTitle>
        </Block>
        <Block>
          <BlockTitle>Car State</BlockTitle>
          <BlockBody>
            <Digits>{distanceRounded}</Digits> cm
            <br />
            <Digits>{velocityRounded}</Digits> cm/sec
            <br />
            <Digits>{accelerationRounded}</Digits> cm/sec<sup>2</sup>
          </BlockBody>
        </Block>
      </Container>
    );
  }
}
