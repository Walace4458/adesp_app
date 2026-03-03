enum GabineteUserRole {
  member,
  pastor,
  secretaria,
}

enum GabineteRequestStatus {
  pendingAdminApproval,
  confirmed,
  canceled,
  completed,
  expired,
}

enum GabineteAssignmentPolicy {
  adminDecides,
  memberChoosesPastor,
}

extension GabineteUserRoleX on GabineteUserRole {
  bool get isAdmin => this == GabineteUserRole.pastor || this == GabineteUserRole.secretaria;
}

String gabineteUserRoleToJson(GabineteUserRole role) => role.name;
  GabineteUserRole gabineteUserRoleFromJson(String value) =>
    GabineteUserRole.values.firstWhere((e) => e.name == value);

String gabineteRequestStatusToJson(GabineteRequestStatus s) => s.name;
  GabineteRequestStatus gabineteRequestStatusFromJson(String value) => 
    GabineteRequestStatus.values.firstWhere((e) => e.name == value);

String gabineteAssignmentPolicyToJson(GabineteAssignmentPolicy p) => p.name;
  GabineteAssignmentPolicy gabineteAssignmentPolicyFromJson(String value) =>
    GabineteAssignmentPolicy.values.firstWhere((e) => e.name == value);