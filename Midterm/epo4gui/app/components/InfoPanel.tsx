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
    const { position } = this.props.carState;
    const distance = position;
    const distanceRounded = Math.round(distance);
    return (
      <Container>
        <Block>
          <BlockTitle>Timer</BlockTitle>
        </Block>
        <Block>
          <BlockTitle>Voice Command</BlockTitle>
        </Block>
        <Block>
          <BlockTitle>Distance from Wall</BlockTitle>
          <BlockBody>
            <Digits>{distanceRounded}</Digits> cm
          </BlockBody>
        </Block>
      </Container>
    );
  }
}
