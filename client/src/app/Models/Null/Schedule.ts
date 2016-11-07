import { Route } from '../Route';
import { ISchedule } from '../Schedule';

export class Schedule implements ISchedule {
  public x : number;
  public y: number;
  public routes: Array<Route>;

  public constructor() {
    this.x = 0;
    this.y = 0;
    this.routes = new Array<Route>();
  }
}
