import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.scroll()
  }

  scroll() {
    setTimeout(() => {
      const messages = this.element.querySelectorAll(".user-message")
      console.log("Found user messages:", messages.length)
      console.log("All messages:", this.element.querySelectorAll(".d-flex").length)
      const lastUserMessage = [...messages].reverse()[0]
      console.log("Last user message:", lastUserMessage)
      if (lastUserMessage) {
        lastUserMessage.scrollIntoView({ behavior: "smooth", block: "start" })
      } else {
        this.element.scrollTop = this.element.scrollHeight
      }
    }, 100)
  }
}
