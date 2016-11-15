import * as React from 'react';

import { RouteComponent } from './Route'
import * as Null from '../Models/Null/Schedule';
import { Schedule } from '../Models/Schedule';
import { Route } from '../Models/Route';
import { RestBus } from '../ServiceProviders/RestBus';

export interface IScheduleProps {
}

export class ScheduleComponent extends React.Component<IScheduleProps, Schedule> {
  constructor(props: IScheduleProps, context) {
    super(props, context);

    this.state = new Null.Schedule();
    ;
  }

  componentDidMount() {
    this.getPosition((position) =>{
      let x = position.coords.latitude;
      let y = position.coords.longitude;

      new RestBus(x, y)
      .fetchSchedule((schedules) => {
        // reload the state
        // so that the controller re-renders
        this.setState(schedules);
      });
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

  private getPosition(callback) {
    navigator.geolocation.getCurrentPosition(callback);
  }
}
