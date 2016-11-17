import * as React from 'react';

import * as models from '../Models/Arrival';

export interface IArrivalProps {
  arrival : models.Arrival;
}

export class ArrivalComponent extends React.Component<IArrivalProps, models.Arrival> {
  constructor(props: IArrivalProps, context) {
    super(props, context);

    this.state = props.arrival;
  }

  componentDidMount() {
  }

  render() {
    return (
      <tr>
        <td>
          {this.state.title}
        </td>
        <td>
          {this.state.time}
        </td>
      </tr>
    )
  }
}
