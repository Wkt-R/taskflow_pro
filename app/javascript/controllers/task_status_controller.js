import { Controller } from "@hotwired/stimulus"
import { StatusManager } from "../services/status_manager"
import { ProgressTracker } from "../services/progress_tracker"
import { QuickStats } from "../services/quick_stats"
import { FlashMessenger } from "../services/flash_messenger"

export default class extends Controller {
  static targets = ["progressBar", "completedCount", "totalCount", "status"]
  static values = { 
    projectId: { type: String, default: '' }  
  }

  initialize() {
    this.statusManager = new StatusManager(this)
    this.progressTracker = new ProgressTracker(this)
    this.quickStats = new QuickStats()
    this.flashMessenger = new FlashMessenger()
  }

  async updateStatus(event) {
    const { value: newStatus, dataset: { taskId } } = event.target
    const projectId = this.resolveProjectId()

    try {
      await this.statusManager.updateStatus(projectId, taskId, newStatus)
      this.handleUpdateSuccess(taskId, newStatus)
    } catch (error) {
      this.statusManager.handleUpdateError(error, event, taskId)
    }
  }

  resolveProjectId() {
    return this.projectIdValue || 
           this.element.dataset.taskStatusProjectIdValue || 
           this.extractProjectIdFromURL()
  }

  extractProjectIdFromURL() {
    const match = window.location.pathname.match(/\/projects\/(\d+)/)
    return match?.[1] || null
  }

  handleUpdateSuccess(taskId, newStatus) {
    this.statusManager.updateTaskUI(taskId, newStatus)
    this.updateProjectStats()
    this.flashMessenger.show("Status updated successfully!", "success")
  }

  updateProjectStats() {
    this.progressTracker.update()
    this.quickStats.update()
  }

  showFlash(message, type) {
    this.flashMessenger.show(message, type)
  }

  findStatusTarget(taskId) {
    return this.statusTargets.find(target => target.dataset.taskId === taskId)
  }
}