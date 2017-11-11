module RestBus exposing ()

getRoutes : String -> Json
getRoutes url =
    Json.Decode url
        |> Schedule.fromJson

export class RestBus {
  public x : number;
  public y : number;

  public constructor(x : number, y : number) {
    this.x = x;
    this.y = y;
  }

  public routes(callback) {
    $
    .ajax(this.stopsUrl(this.x, this.y))
    .done((data) => {
      let routes = this.parseResponse(data);

      callback(routes);
      // let schedule = new Schedule(this.x, this.y, routes)
      //
      // callback(schedule);
    });
  }

  private stopsUrl(x, y) {
    return `${Config.restbusUrl}/nearby/index?longitude=${x}&latitude=${y}`;
  }

  private parseResponse(data) : Array<Route> {
    let routes = [];

    for (let item of data) {
      if (!item.route) {
        continue;
      }

      let route = new Route(item.route.id, item.route.title, []);

      // Schedule
      let values = item.values;
      for (let value of values) {
        // Title of arrival or direction
        let title = value.direction.title;
        // Arrival time in minutes
        let time = value.minutes > 0 ? value.minutes : 'now';

        if (item.agency.id === 'ttc') {
          let arrival = new Ttc(title, time);
          route.arrivals.push(arrival);
        } else {
          let arrival = new Arrival(title, time);
          route.arrivals.push(arrival);
        }
      }

      routes.push(route);
    }

    return routes;
  }
}
