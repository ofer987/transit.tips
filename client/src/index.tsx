/// <reference path="../typings/index.d.ts" />

import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Router, Route, browserHistory } from 'react-router';

import { ScheduleComponent } from './app/Components/Schedule'

import 'bootstrap/dist/css/bootstrap.css';
import './styles.scss';

ReactDOM.render(
  <ScheduleComponent />,
  document.getElementById('root')
);
