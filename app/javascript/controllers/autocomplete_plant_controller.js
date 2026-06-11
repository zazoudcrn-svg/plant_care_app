import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  static targets = ["input", "results"]

  connect() {
    console.log("Autocomplete Controller erfolgreich verbunden und bereit! 🌿")
  }

  async search() {
    const query = this.inputTarget.value.trim()
    console.log("User tippt gerade:", query)


    if (query.length < 3) {
      this.clearResults()
      return
    }

    try {
      console.log(`Sende Anfrage an Backend: /plants/search?query=${query}`)
      const response = await fetch(`/plants/search?query=${encodeURIComponent(query)}`)
      const plants = await response.json()

      console.log("Ergebnisse vom Backend erhalten:", plants)
      this.displayResults(plants)
    } catch (error) {
      console.error("Fehler beim Abrufen der Pflanzen:", error)
    }
  }

  displayResults(plants) {
    this.clearResults()

    if (plants.length === 0) {
      console.log("Keine passenden Pflanzen in der API gefunden.")
      return
    }


    const dropdown = document.createElement("div")
    dropdown.style.position = "absolute"
    dropdown.style.width = "100%"
    dropdown.style.backgroundColor = "white"
    dropdown.style.border = "1px solid #ccc"
    dropdown.style.borderRadius = "4px"
    dropdown.style.zIndex = "1000"
    dropdown.style.maxHeight = "200px"
    dropdown.style.overflowY = "auto"
    dropdown.style.boxShadow = "0px 4px 6px rgba(0,0,0,0.1)"

    plants.forEach(plant => {
      const item = document.createElement("div")
      item.style.padding = "8px 12px"
      item.style.cursor = "pointer"
      item.style.color = "#333"
      item.innerHTML = `<strong>${plant.common_name}</strong> <small style="color: #666; font-style: italic;">(${plant.scientific_name})</small>`


      item.addEventListener("click", () => {
        console.log("User hat Pflanze ausgewählt:", plant.common_name)
        this.inputTarget.value = plant.common_name
        this.clearResults()
      })

      item.addEventListener("mouseenter", () => item.style.backgroundColor = "#f3f4f6")
      item.addEventListener("mouseleave", () => item.style.backgroundColor = "white")

      dropdown.appendChild(item)
    })

    this.resultsTarget.appendChild(dropdown)
  }

  clearResults() {
    this.resultsTarget.innerHTML = ""
  }
}
