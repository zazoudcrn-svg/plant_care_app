import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.scroll()
  }

  scroll() {
    setTimeout(() => {
      this.element.scrollTop = this.element.scrollHeight
    }, 100)
  }
}
