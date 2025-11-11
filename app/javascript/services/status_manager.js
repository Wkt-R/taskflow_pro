import { StatusConstants } from "./constants/status_constants"

export class StatusManager {
  constructor(controller) {
    this.controller = controller
  }

  async updateStatus(projectId, taskId, newStatus) {
    this.validateUpdateParams(projectId, taskId)
    this.showLoadingState(taskId)
    
    await this.performApiUpdate(projectId, taskId, newStatus)
  }

  validateUpdateParams(projectId, taskId) {
    if (!projectId || !taskId) {
      throw new Error("Missing project or task information")
    }
  }

  showLoadingState(taskId) {
    const badge = this.controller.findStatusTarget(taskId)
    if (badge) {
      badge.innerHTML = '<span class="animate-pulse text-yellow-400">Updating...</span>'
    }
  }

  async performApiUpdate(projectId, taskId, newStatus) {
    const response = await fetch(`/projects/${projectId}/tasks/${taskId}`, {
      method: "PATCH",
      headers: this.getRequestHeaders(),
      body: JSON.stringify({ task: { status: newStatus } })
    })

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${await response.text()}`)
    }

    return response
  }

  getRequestHeaders() {
    return {
      "X-CSRF-Token": this.getCSRFToken(),
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest"
    }
  }

  getCSRFToken() {
    return document.querySelector("[name='csrf-token']")?.content
  }

  updateTaskUI(taskId, newStatus) {
    this.updateStatusBadge(taskId, newStatus)
    this.updateTaskCardData(taskId, newStatus)
  }

  updateStatusBadge(taskId, status) {
    const badge = this.controller.findStatusTarget(taskId)
    if (!badge) return

    const displayText = this.formatStatusText(status)
    const colorClass = StatusConstants.COLORS[status] || "bg-gray-500"
    
    badge.innerHTML = `
      <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium ${colorClass} text-white">
        ${displayText}
      </span>
    `
  }

  updateTaskCardData(taskId, status) {
    const taskCard = this.findTaskCard(taskId)
    if (taskCard) {
      taskCard.dataset.status = status
      taskCard.dataset.originalStatus = status
    }
  }

  handleUpdateError(error, event, taskId) {
    console.error("Status update failed:", error)
    this.controller.showFlash("Error updating task status", "error")
    this.revertSelectValue(event, taskId)
  }

  revertSelectValue(event, taskId) {
    event.target.value = this.getOriginalStatus(taskId)
  }

  findTaskCard(taskId) {
    return document.querySelector(`[data-task-id="${taskId}"]`)?.closest('[data-status]')
  }

  getOriginalStatus(taskId) {
    const taskCard = this.findTaskCard(taskId)
    return taskCard?.dataset.originalStatus || StatusConstants.TYPES.BACKLOG
  }

  formatStatusText(status) {
    return status.split('_')
      .map(word => word.charAt(0).toUpperCase() + word.slice(1))
      .join(' ')
  }
}