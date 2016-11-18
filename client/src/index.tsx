/// <reference path="../typings/index.d.ts" />

import * as React from 'react';
import * as ReactDOM from 'react-dom';
import { Router, Route, browserHistory } from 'react-router';

import { StartupComponent } from './app/Components/Startup'

import 'bootstrap/dist/css/bootstrap.css';
import './styles.scss';

ReactDOM.render(
  <StartupComponent />,
  document.getElementById('root')
);
