import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["content", "tooltip"];

  copy(event) {
    event.stopPropagation();
    event.preventDefault();

    const content = this.contentTarget.innerText;
    const input_temp = document.createElement("input");

    input_temp.value = content;
    document.body.appendChild(input_temp);

    input_temp.select();
    document.execCommand("copy");
    document.body.removeChild(input_temp);

    this.showConfirmation();
  }

  showConfirmation() {
    const tooltip = document.createElement("div");
    tooltip.classList.add("clipboard", "tooltip");
    tooltip.innerText = "Copied to clipboard";

    this.tooltipTarget.appendChild(tooltip);

    this.timeoutID = window.setTimeout(this.clearTooltip.bind(this), 1000);
  }

  clearTooltip() {
    const tooltips = this.tooltipTarget.querySelectorAll(".tooltip")

    if (tooltips) {
      tooltips.forEach((element) => {
        element.remove()
      });
    }

    if (this.timeoutID) {
      clearTimeout(this.timeoutID)
    }
  }
}
