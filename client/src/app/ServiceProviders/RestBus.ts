import { Arrival } from '../Models/Arrival';
import { Route } from '../Models/Route';
import { Schedule } from '../Models/Schedule';
import $ = require('jquery');

export class RestBus {
  public x : number;
  public y : number;

  public constructor(x : number, y : number) {
    this.x = x;
    this.y = y;
  }

  public fetchSchedule(callback) {
    $
    .ajax(this.stopsUrl(this.x, this.y))
    .done((data) => {
      let routes = this.parseResponse(data);
      let schedule = new Schedule(this.x, this.y, routes)

      callback(schedule);
    });
  }

  private stopsUrl(x, y) {
    return "https://restbus.transit.tips/nearby?longitude=${x}&latitude=${y}";
  }

  private parseResponse(data) : Array<Route> {
    let routes = [];

    for (let item of data) {
      let route = new Route(item.route.title, []);

      // Schedule
      let values = item.values;
      for (let value of values) {
        // Name of arrival or direction
        let name = value.direction.title;
        // Arrival time in minutes
        let time = value.minutes > 0 ? value.minutes : 'now';

        let arrival = new Arrival(name, time);
        route.arrivals.push(arrival);
      }

      routes.push(route);
    }

    return routes;
  }
}
