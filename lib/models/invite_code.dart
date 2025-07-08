class InviteCode {
  int id;
  String code;
  bool isUsed;
  DateTime? usedAt;

  InviteCode({
    required this.id,
    required this.code,
    required this.isUsed,
    this.usedAt
  });

}
