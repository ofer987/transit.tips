export class Arrival {
  protected _title : string;
  public time : number;

  constructor(title : string, time : number) {
    this._title = title;
    this.time = time;
  }

  get title() : string {
    return this._title;
  }
}
