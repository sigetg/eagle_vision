import { Controller } from "@hotwired/stimulus"

// Shows and hides a target: the Filters button on a phone, and the inline
// "Withdraw this request?" confirmation.
export default class extends Controller {
  static targets = [ "panel" ]

  toggle() {
    this.panelTargets.forEach((panel) => {
      panel.hidden = !panel.hidden
      panel.classList.toggle("open")
    })
  }
}
