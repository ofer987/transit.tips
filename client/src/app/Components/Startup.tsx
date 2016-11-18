import * as React from 'react';

import { LoadingComponent } from './Loading';
import { ScheduleComponent } from './Schedule';
import { Schedule } from '../Models/Schedule';

export interface IStartupProps {
}

export class StartupComponent extends React.Component<IStartupProps, {}> {
  private _schedule : Schedule;
  private _isScheduleReady : boolean;

  constructor(props: IStartupProps, context) {
    super(props, context);

    this._isScheduleReady = false;
  }

  componentDidMount() {
    let schedule = new Schedule();

    schedule.initialize(() => {
      this._isScheduleReady = true;
      this._schedule = schedule;

      this.forceUpdate();
    });
  }

  render() {
    if (this._isScheduleReady) {
      return (
        <ScheduleComponent schedule={this._schedule} />
      )
    } else {
      return (
        <LoadingComponent />
      )
    }
  }
}
