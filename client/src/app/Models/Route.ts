import { Arrival } from "./Arrival";
import { Config } from '../Config';

import $ = require('jquery');

export class Route {
  public title : string;
  public id : string;
  public arrivals : Array<Arrival>;

  private _condition : boolean;
  public get condition() : boolean {
    return this._condition;
  }

  constructor(id : string, title : string, arrivals : Array<Arrival>) {
    this.id = id;
    this.title = title;
    this.arrivals = arrivals;
    this._condition = true;
  }

  updateCondition() {
    $
    .ajax(this.reportUrl(this.id))
    .done((data) => {
      let condition = data.attributes.condition;

      this._condition = condition !== 'red'
    }).fail(() => {
      this._condition = true;
    });
  }

  private reportUrl(id : string) : string {
    return `${Config.ttcNoticesUrl}/lines/${id}/report`;
  }
}
