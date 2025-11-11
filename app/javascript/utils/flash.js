export function showFlash(message, type = "success") {
  document.querySelectorAll(".flash-message").forEach(e => e.remove())
  const el = document.createElement("div")
  el.className = `flash-message fixed top-4 right-4 p-4 rounded-lg text-white z-50 ${
    type === "success" ? "bg-green-500" : "bg-red-500"
  }`
  el.textContent = message
  document.body.appendChild(el)
  setTimeout(() => el.remove(), 3000)
}
