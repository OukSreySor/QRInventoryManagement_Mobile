class ItemStatusChangeLog {
  final String oldStatus;
  final String newStatus;
  final DateTime changedAt;
  final String changedByUser;
  final String? note;

  ItemStatusChangeLog({
    required this.oldStatus,
    required this.newStatus,
    required this.changedAt,
    required this.changedByUser,
    this.note,
  });

  factory ItemStatusChangeLog.fromJson(Map<String, dynamic> json) {
    return ItemStatusChangeLog(
      oldStatus: json['oldStatus'],
      newStatus: json['newStatus'],
      changedAt: DateTime.parse(json['changedAt']),
      changedByUser: json['changeByUser'],
      note: json['note'],
    );
  }
}
