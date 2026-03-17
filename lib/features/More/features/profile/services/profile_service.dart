import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile.dart';

class ProfileService {

  static Future<void> save(UserProfile user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('name', user.name ?? '');
    await prefs.setString('avatar', user.avatarPath ?? '');
    await prefs.setString('birthDate', user.birthDate ?? '');
    await prefs.setString('gender', user.gender ?? '');
    await prefs.setString('phone', user.phone ?? '');
    await prefs.setString('email', user.email ?? '');
    await prefs.setString('church', user.church ?? '');
    await prefs.setString('ministry', user.ministry ?? '');
    await prefs.setString('cpf', user.cpf ?? '');
    await prefs.setString('rg', user.rg ?? '');
  }

  static Future<UserProfile> load() async {
    final prefs = await SharedPreferences.getInstance();

    return UserProfile(
      name: prefs.getString('name'),
      avatarPath: prefs.getString('avatar'),
      birthDate: prefs.getString('birthDate'),
      gender: prefs.getString('gender'),
      phone: prefs.getString('phone'),
      email: prefs.getString('email'),
      church: prefs.getString('church'),
      ministry: prefs.getString('ministry'),
      cpf: prefs.getString('cpf'),
      rg: prefs.getString('rg'),
    );
  }
}