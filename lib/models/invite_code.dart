class InviteCode {
  int id;
  String code;
  bool isUsed;
  DateTime? usedAt;
  DateTime? createdAt;

  InviteCode({
    required this.id,
    required this.code,
    required this.isUsed,
    this.usedAt,
    this.createdAt,
  });

   factory InviteCode.fromJson(Map<String, dynamic> json) {
    return InviteCode(
      id: json['id'],
      code: json['code'],
      isUsed: json['isUsed'],
      usedAt: json['usedAt'] != null ? DateTime.parse(json['usedAt']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'isUsed': isUsed,
      'usedAt': usedAt?.toIso8601String(),
    };
  }
}
