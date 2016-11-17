import { Arrival } from "./Arrival";
import { Config } from '../Config';

import $ = require('jquery');

export class Route {
  public title : string;
  public name : string;
  public arrivals : Array<Arrival>;

  constructor(name, arrivals) {
    this.name = name;
    this.arrivals = arrivals;
  }

  condition(id : number) {
    $
    .ajax(this.reportUrl(id))
    .done((data) => {
      let condition = data.attributes.condition;

      return condition !== 'red'
    });
  }

  private reportUrl(id : number) : string {
    return `${Config.ttcNoticesUrl}/lines/${id}/report`;
  }
}
