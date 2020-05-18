import React, { Component } from 'react';
import styled from 'styled-components';

const Container = styled.div`
  flex: 0 0 auto;
  width: 16rem;
  background: #ffe8c0;
  box-shadow: 0px 10px 0px #c19f67;
  border-radius: 12px;
  margin: 1rem;
  padding: 1rem;
  color: #423114;
`;

export default class ConfigPanel extends Component {
  render() {
    return <Container>Config Panel</Container>;
  }
}
