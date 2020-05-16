import {
  ADD_WEBSOCKET_TO_STORE,
  ON_MESSAGE_RECEIVED
} from '../actions/websocket';

const initialState = {
  ws: null,
  carState: {}
};

export default (state = initialState, { type, payload }) => {
  switch (type) {
    case ADD_WEBSOCKET_TO_STORE:
      return { ...state, ws: payload.ws };
    case ON_MESSAGE_RECEIVED:
      return { ...state, carState: payload.carState };

    default:
      return state;
  }
};
