/// <reference path="../typings/index.d.ts" />

import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Router, Route, browserHistory } from 'react-router';

import { ScheduleComponent } from './app/Components/Schedule'

import 'bootstrap/dist/css/bootstrap.css';

// import './index.styl';

ReactDOM.render(
  // <Router history={browserHistory}>
  //   <Route path='/' component={Hello}/>
  // </Router>,
  <ScheduleComponent />,
  document.getElementById('root')
);
