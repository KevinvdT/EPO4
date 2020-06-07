import React, { Component } from 'react';
import styled from 'styled-components';

import ConfigPanel from './ConfigPanel';
import MapPanel from './MapPanel';
import InfoPanel from './InfoPanel';

const FlexContainer = styled.div`
  display: flex;
  flex-direction: row;
  align-items: stretch;
  align-content: stretch;
  height: 100vh;
`;

export default class AppContainer extends Component {
  render() {
    const { carState } = this.props;
    return (
      <FlexContainer>
        <ConfigPanel carState={carState} />
        <MapPanel carState={carState} />
        <InfoPanel carState={carState} />
      </FlexContainer>
    );
  }
}
