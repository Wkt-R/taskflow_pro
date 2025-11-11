import "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import TaskStatusController from "./controllers/task_status_controller"

const application = Application.start()

application.register("task-status", TaskStatusController)

window.Stimulus = application