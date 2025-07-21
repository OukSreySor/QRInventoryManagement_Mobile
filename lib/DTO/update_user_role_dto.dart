class UpdateUserRoleDTO {
  String userId;
  String newRole;

  UpdateUserRoleDTO({
    required this.userId,
    required this.newRole,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'newRole': newRole,
    };
  }
}
