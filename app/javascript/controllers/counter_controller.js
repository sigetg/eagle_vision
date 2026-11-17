import { Controller } from "@hotwired/stimulus"

// A live character counter under the reason box.
export default class extends Controller {
  static targets = [ "input", "output" ]
  static values = { max: Number }

  connect() { this.update() }

  update() {
    const left = this.maxValue - this.inputTarget.value.length
    this.outputTarget.textContent = `${left} characters left`
  }
}
