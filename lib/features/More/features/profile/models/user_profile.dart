class UserProfile {
  String? name;
  String? avatarPath;

  String? birthDate;
  String? gender;

  String? phone;
  String? email;

  String? church;
  String? ministry;

  String? cpf;
  String? rg;

  UserProfile({
    this.name,
    this.avatarPath,
    this.birthDate,
    this.gender,
    this.phone,
    this.email,
    this.church,
    this.ministry,
    this.cpf,
    this.rg,
  });

  double get completion {
    int total = 6;
    int filled = 0;

    if (name?.isNotEmpty ?? false) filled++;
    if (birthDate?.isNotEmpty ?? false) filled++;
    if (gender?.isNotEmpty ?? false) filled++;
    if (phone?.isNotEmpty ?? false) filled++;
    if (email?.isNotEmpty ?? false) filled++;
    if (cpf?.isNotEmpty ?? false) filled++;

    return filled / total;
  }
}