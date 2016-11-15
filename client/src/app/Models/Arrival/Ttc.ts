import { Arrival } from "../Arrival";

export class Ttc extends Arrival {
  public name : string;
  public time : number;

  constructor(name : string, time : number) {
    this.name = name;
    this.time = time;
  }

  get name() : string {
    let regex = new RegExp(/To:\s+(.*)\s+-\s+.*\s+towards\s+(.*)/)

    matches = regex.exec(this._name)
    if (matches !== null && matches.length >= 2) {
      let direction = matches[1];
      let destination = matches[2];

      return `${direction} (${destination})`;
    }

    return this._name;
  }
}
