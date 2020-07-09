import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [];

  print(event) {
    event.stopPropagation();
    event.preventDefault();

    window.print();
  }
}
