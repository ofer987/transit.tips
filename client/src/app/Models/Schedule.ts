import { Arrival } from './Arrival';
import { Route } from './Route';
import { RestBus } from '../ServiceProviders/RestBus';

export interface ISchedule {
  x : number;
  y: number;
  routes: Array<Route>;
}

export class Schedule implements ISchedule {
  public x : number;
  public y: number;
  public routes: Array<Route>;

  public constructor() {
    this.x = 0;
    this.y = 0;
    this.routes = [];
  }

  public initialize(done) {
    navigator.geolocation.getCurrentPosition((position) =>{
      this.x = position.coords.latitude;
      this.y = position.coords.longitude;

      new RestBus(this.x, this.y).routes((routes) => {
        // reload the state
        // so that the controller re-renders
        this.routes = routes;
        done();
      });
    });
  }
}
