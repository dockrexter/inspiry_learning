enum WorkStatus {
  compleated,
  inProgress,
  pendingPayment,
}

WorkStatus getWorkStatus(String status) {
  switch (status) {
    case 'Work Completed':
      return WorkStatus.compleated;
    case 'Work in Progress':
      return WorkStatus.inProgress;
    case 'Pending Payment':
      return WorkStatus.pendingPayment;
    default:
      return WorkStatus.inProgress;
  }
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
