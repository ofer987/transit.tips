import * as React from 'react';

import { Route } from '../Models/Route';
import { Arrival } from '../Models/Arrival';
import { ArrivalComponent } from './Arrival';

export interface IRouteProps {
  route : Route;
}

export class RouteComponent extends React.Component<IRouteProps, Route> {
  constructor(props: IRouteProps, context) {
    super(props, context);

    this.state = props.route;
  }

  componentDidMount() {
  }

  render() {
    return (
      <div className='panel-heading'>
        <h3 className='panel-title'>{this.state.title}</h3>

        <div className='panel-body'>
          {this.state.name}
        </div>

        <table className='table'>
          <thead>
            <tr>
              <th id="direction">Direction</th>
              <th id="arrival">Arrival (in minutes)</th>
            </tr>
          </thead>

          <tbody>
            {this.arrivalComponents(this.state.arrivals)}
          </tbody>
        </table>
      </div>
    )
  }

  private arrivalComponents(arrivals : Array<Arrival>) {
    let components = [];
    for (let index in arrivals) {
      components.push(<ArrivalComponent key={'route_' + index} arrival={arrivals[index]} />);
    }

    return components;
  }
}
