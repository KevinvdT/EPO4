export const ADD_WEBSOCKET_TO_STORE = 'ADD_WEBSOCKET_TO_STORE';
export const ON_MESSAGE_RECEIVED = 'ON_MESSAGE_RECEIVED';

export const addWebsocketToStore = ws => dispatch => {
  return dispatch({
    type: ADD_WEBSOCKET_TO_STORE,
    payload: {
      ws
    }
  });
};

export const onMessageReceived = event => dispatch => {
  const rawMessage = event.data;
  const message = JSON.parse(rawMessage);
  return dispatch({
    type: ON_MESSAGE_RECEIVED,
    payload: {
      carState: message
    }
  });
};
