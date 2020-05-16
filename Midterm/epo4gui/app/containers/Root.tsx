import React from 'react';
import { Provider } from 'react-redux';
import { ConnectedRouter } from 'connected-react-router';
import { hot } from 'react-hot-loader/root';
import { History } from 'history';
import { Store } from '../reducers/types';
import Routes from '../Routes';
import WebSocket from '../utils/WebSocket';

type Props = {
  store: Store;
  history: History;
};

const Root = ({ store, history }: Props) => (
  <WebSocket>
    <Provider store={store}>
      <ConnectedRouter history={history}>
        <Routes />
      </ConnectedRouter>
    </Provider>
  </WebSocket>
);

export default hot(Root);
