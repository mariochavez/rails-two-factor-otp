import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["link", "content"];

  connect() {
    this.linkTarget.download = "recovery codes.txt";
    this.linkTarget.href = "data:text/plain;charset=UTF-8," + this.contentTarget.innerText.replace(/ /g, "%0D%0A");
  }
}
