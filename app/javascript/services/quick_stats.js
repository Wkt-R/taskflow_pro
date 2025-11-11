export class QuickStats {
  update() {
    const statusCount = this.calculateStatusCounts()
    this.renderQuickStats(statusCount)
  }

  calculateStatusCounts() {
    const taskCards = this.getTaskCards()
    const statusCount = {
      backlog: 0,
      todo: 0,
      in_progress: 0,
      review: 0,
      done: 0
    }

    taskCards.forEach(card => {
      const status = card.dataset.status
      if (statusCount[status] !== undefined) {
        statusCount[status]++
      }
    })

    return statusCount
  }

  renderQuickStats(statusCount) {
    const statsContainer = document.querySelector('[data-quick-stats]')
    if (!statsContainer) {
      console.warn("Quick stats container not found")
      return
    }

    Object.entries(statusCount).forEach(([status, count]) => {
      const countElement = statsContainer.querySelector(`[data-status="${status}"]`)
      if (countElement) {
        countElement.textContent = count
      }
    })
  }

  getTaskCards() {
    return Array.from(document.querySelectorAll('.task-card[data-status]'))
  }
}