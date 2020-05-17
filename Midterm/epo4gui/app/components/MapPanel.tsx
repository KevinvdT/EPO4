import React, { Component } from 'react';
import styled from 'styled-components';

const Container = styled.div`
  flex: 1 1 auto;
  background: blue;
  border: 1px solid red;
`;

export default class MapPanel extends Component {
  render() {
    return <Container>MapPanel</Container>;
  }
}
