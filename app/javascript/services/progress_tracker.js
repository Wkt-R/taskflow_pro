export class ProgressTracker {
  constructor(controller) {
    this.controller = controller
  }

  update() {
    const { doneTasks, totalTasks } = this.calculateTaskStats()
    
    if (totalTasks === 0) return

    const percentage = Math.round((doneTasks / totalTasks) * 100)
    
    this.updateProgressBar(percentage)
    this.updateProgressText(percentage)
    this.updateTaskCounts(doneTasks, totalTasks)
  }

  calculateTaskStats() {
    const taskCards = this.getTaskCards()
    const doneTasks = taskCards.filter(card => card.dataset.status === 'done').length
    const totalTasks = taskCards.length

    return { doneTasks, totalTasks }
  }

  updateProgressBar(percentage) {
    if (this.controller.hasProgressBarTarget) {
      this.controller.progressBarTarget.style.width = `${percentage}%`
    }
  }

  updateProgressText(percentage) {
    const progressText = document.querySelector('.progress-percentage')
    if (progressText) {
      progressText.textContent = `${percentage}%`
    }
  }

  updateTaskCounts(doneTasks, totalTasks) {
    if (this.controller.hasCompletedCountTarget) {
      this.controller.completedCountTarget.textContent = doneTasks
    }
    
    if (this.controller.hasTotalCountTarget) {
      this.controller.totalCountTargets.forEach(target => {
        target.textContent = totalTasks
      })
    }
  }

  getTaskCards() {
    return Array.from(document.querySelectorAll('.task-card[data-status]'))
  }
}