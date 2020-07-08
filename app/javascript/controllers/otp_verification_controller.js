import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["verification"];

  cleanForm() {
    const p = this.verificationTarget.querySelector(".help");
    if (p) {
      p.remove();
    }
  }

  result(response) {
    const errorMessage = response.detail[0].error;
    const p = document.createElement("p");

    p.classList.add("help", "is-danger")
    p.innerText = errorMessage;
    this.verificationTarget.appendChild(p);
  }
}
