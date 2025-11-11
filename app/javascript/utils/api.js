export async function patchTaskStatus(projectId, taskId, status) {
  const res = await fetch(`/projects/${projectId}/tasks/${taskId}`, {
    method: "PATCH",
    headers: {
      "X-CSRF-Token": document.querySelector("[name='csrf-token']")?.content,
      "Content-Type": "application/json",
      "X-Requested-With": "XMLHttpRequest"
    },
    body: JSON.stringify({ task: { status } })
  })
  if (!res.ok) throw new Error(`HTTP ${res.status}`)
  return res
}
