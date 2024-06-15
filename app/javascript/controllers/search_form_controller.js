import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]
  search() {
    clearTimeout(this.timer)
    this.timer = setTimeout(() => {
      this.element.requestSubmit()
    }, 200) 
  }

  clear() {
    this.inputTarget.value = ""
    this.element.requestSubmit()
  }
}
