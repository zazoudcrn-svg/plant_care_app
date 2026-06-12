document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll("[data-upload-trigger]").forEach(trigger => {
    const plantId = trigger.dataset.uploadTrigger
    const fileInput = document.querySelector(`#file-input-${plantId}`)
    const form = document.querySelector(`#upload-form-${plantId}`)

    if (!fileInput || !form) return

    trigger.addEventListener("click", () => fileInput.click())
    fileInput.addEventListener("change", () => form.submit())
  })
})
