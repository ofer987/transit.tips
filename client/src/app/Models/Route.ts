import { Arrival } from "./Arrival";

export class Route {
  public title : string;
  public name : string;
  public arrivals : Array<Arrival>;

  constructor(name, arrivals) {
    this.name = name;
    this.arrivals = arrivals;
  }
}
