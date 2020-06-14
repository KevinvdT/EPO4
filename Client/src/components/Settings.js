import React, { Component } from "react";
import ReactModal from "react-modal";
import styled from "styled-components";

const Header = styled.div`
  text-align: center;
  background: #4f4f4f;
  /* height: 3.1rem; */
  flex: 0 0 3.1rem;
  display: flex;
  flex-direction: column;
  justify-content: center;
`;

const Body = styled.div`
  flex: 1 0 auto;
  text-align: center;
  padding: 0.5rem;
`;

const Title = styled.div``;

const Icon = styled.div``;

export default class Settings extends Component {
  render() {
    const style = {
      overlay: {
        backgroundColor: "rgba(0, 0, 0, 0.2)",
        "-webkit-backdrop-filter": "saturate(180%) blur(15px)",
        "backdrop-filter": "saturate(180%) blur(15px)",
      },
      content: {
        maxWidth: "30rem",
        bottom: "initial",
        borderRadius: 0,
        marginLeft: "auto",
        marginRight: "auto",
        top: "10rem",
        display: "flex",
        flexDirection: "column",
        alignItems: "stretch",
        background: "#3c3c3c",
        padding: 0,
        border: "none",
      },
    };

    const { isOpen, closeSettings } = this.props;
    return (
      <ReactModal isOpen={isOpen} style={style}>
        <Header>
          <Icon></Icon>
          <Title>Settings</Title>
        </Header>
        <Body>
          <div onClick={closeSettings}>Close me</div>
        </Body>
      </ReactModal>
    );
  }
}
