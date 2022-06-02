enum WorkStatus {
  compleated,
  inProgress,
  pendingPayment,
}

String getStatus(WorkStatus status) {
  switch (status) {
    case WorkStatus.compleated:
      return "Work Completed";
    case WorkStatus.inProgress:
      return "Work in progress";
    case WorkStatus.pendingPayment:
      return "Pending Payment";
  }
}
