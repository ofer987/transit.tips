import * as React from 'react';

import { RouteComponent } from './Route'
import { Schedule } from '../Models/Schedule';
import { Route } from '../Models/Route';
import { RestBus } from '../ServiceProviders/RestBus';

export interface IScheduleProps {
  schedule : Schedule;
}

export class ScheduleComponent extends React.Component<IScheduleProps, Schedule> {
  constructor(props: IScheduleProps, context) {
    super(props, context);

    this.state = props.schedule;
  }

  componentDidMount() {
    let schedule = new Schedule();

    schedule.initialize(() => {
      this.setState(schedule);
    });
  }

  render() {
    return (
      <table className='table' id="schedules">
        <thead>
          <tr>
            <th id="direction">Direction</th>
            <th id="arrival">Arrival (in minutes)</th>
          </tr>
        </thead>
        {this.routeComponents(this.state.routes)}
      </table>
    )
  }

  private routeComponents(routes : Array<Route>) {
    let components = [];
    for (let index in routes) {
      components.push(<RouteComponent key={'route_' + index} route={routes[index]} />);
    }

    return components;
  }
}
