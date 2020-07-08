import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["slide"];

  connect() {
    this.showSlide(1);
  }

  disconnect() {
    this.showSlide(1);
  }

  next(event) {
    event.stopPropagation();
    event.preventDefault();

    this.showSlide(this.index + 1);
  }

  back(event) {
    if (this.index !== 1) {
      event.stopPropagation();
      event.preventDefault();

      this.showSlide(this.index - 1);
    }
  }

  showSlide(index) {
    this.index = index;
    this.slideTargets.forEach((element) => {
      let idx = parseInt(element.getAttribute("data-wizard-index"));
      element.classList.toggle("wizard--current", index === idx);
    });
  }
}
