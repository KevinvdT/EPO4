import React from 'react';
// import { Provider } from 'react-redux';
// import { ConnectedRouter } from 'connected-react-router';
import { hot } from 'react-hot-loader/root';
// import { History } from 'history';
// import { Store } from '../reducers/types';
// import Routes from '../Routes';
import WebSocketUtil from '../components/utils/WebSocketUtil';

// type Props = {
//   store: Store;
//   history: History;
// };

const Root = () => <WebSocketUtil />;

export default hot(Root);
