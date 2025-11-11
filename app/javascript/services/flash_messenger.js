export class FlashMessenger {
  show(message, type) {
    this.removeExistingFlash()
    
    const flash = this.createFlashElement(message, type)
    document.body.appendChild(flash)
    
    this.animateFlashIn(flash)
    this.scheduleFlashRemoval(flash)
  }

  removeExistingFlash() {
    document.querySelectorAll('.flash-message').forEach(el => el.remove())
  }

  createFlashElement(message, type) {
    const flash = document.createElement("div")
    flash.className = `flash-message fixed top-4 right-4 p-4 rounded-lg text-white z-50 ${
      type === "success" ? "bg-green-500" : "bg-red-500"
    }`
    flash.textContent = message
    flash.style.transform = 'translateX(100%)'
    return flash
  }

  animateFlashIn(flash) {
    requestAnimationFrame(() => {
      flash.style.transform = 'translateX(0)'
    })
  }

  scheduleFlashRemoval(flash) {
    setTimeout(() => {
      flash.style.transform = 'translateX(100%)'
      setTimeout(() => flash.remove(), 300)
    }, 3000)
  }
}