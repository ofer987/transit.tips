import { Arrival } from './Arrival';
import { Route } from './Route';

export interface ISchedule {
  x : number;
  y: number;
  routes: Array<Route>;
}

export class Schedule implements ISchedule {
  public x : number;
  public y: number;
  public routes: Array<Route>;

  public constructor(x : number, y : number, routes: Array<Route>) {
    this.x = x;
    this.y = y;
    this.routes = routes;
  }
}
