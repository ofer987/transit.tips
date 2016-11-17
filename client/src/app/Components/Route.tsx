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
      <tbody className="route-body">
        <tr>
          <td><span className="route-name">{this.state.name}</span></td>
        </tr>
        {this.renderCondition()}
        {this.arrivalComponents(this.state.arrivals)}
      </tbody>
    )
  }

  private renderCondition() {
    if (!this.state.condition()) {
      return (
        <tr className="condition">Bad</div>
      )
    }
  }

  private arrivalComponents(arrivals : Array<Arrival>) {
    let components = [];

    for (let index in arrivals) {
      components.push(<ArrivalComponent key={'route_' + index} arrival={arrivals[index]} />);
    }

    return components;
  }
}
