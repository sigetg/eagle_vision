import { Controller } from "@hotwired/stimulus"

// Opens and closes the top bar's links on a phone.
export default class extends Controller {
  toggle() {
    this.element.classList.toggle("open")
  }
}
