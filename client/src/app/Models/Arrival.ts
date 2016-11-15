// export interface IArrival {
//   public name : string;
//   public time : number;
// }

export class Arrival {
  protected _name : string;
  public time : number;

  constructor(name : string, time : number) {
    this._name = name;
    this.time = time;
  }

  get name() : string {
    return this._name;
  }
}
