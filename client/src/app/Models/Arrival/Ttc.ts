import { Arrival } from "../Arrival";

export class Ttc extends Arrival {
  constructor(title : string, time : number) {
    super(title, time);
  }

  get title() : string {
    for (let regex of this.regexes()) {
      let matches = regex.exec(this._title)

      if (matches !== null && matches.length >= 2) {
        let direction = matches[1];
        let destination = matches[2];

        return `${direction} (${destination})`;
      }
    }

    return this._title;
  }

  private regexes() : Array<RegExp> {
    return [
      /To:\s+(.*)\s+-\s+.*\s+towards\s+(.*)\s+-\s+Extra Fare Required/,
      /To:\s+(.*)\s+-\s+.*\s+towards\s+(.*)\s+Extra Fare Required/,
      /To:\s+(.*)\s+-\s+.*\s+towards\s+(.*)/
    ];
  }
}
