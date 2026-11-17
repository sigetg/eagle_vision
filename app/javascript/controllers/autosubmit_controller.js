import { Controller } from "@hotwired/stimulus"

// Submits the surrounding form when a field changes: the term picker and the
// course filters use it, so there is no Apply button.
export default class extends Controller {
  submit() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => this.element.requestSubmit(), 150)
  }
}
