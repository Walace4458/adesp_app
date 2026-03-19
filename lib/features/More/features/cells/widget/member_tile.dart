import 'package:flutter/material.dart';
import '../models/member_model.dart';

class MemberTile extends StatelessWidget {
  final MemberModel member;

  const MemberTile(this.member, {super.key});

  bool isBirthdayThisMonth() {
    final now = DateTime.now();
    return member.birthDate.month == now.month;
  }

  @override
  Widget build(BuildContext context) {
    final isBirthday = isBirthdayThisMonth();

    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(member.name),
      trailing: isBirthday
          ? const Icon(Icons.cake, color: Colors.pink)
          : null,
    );
  }
}