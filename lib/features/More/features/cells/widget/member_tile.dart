import 'package:flutter/material.dart';
import '../models/member_model.dart';

class MemberTile extends StatelessWidget {
  final MemberModel member;

  const MemberTile({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.deepPurple.shade100,
            child: const Icon(Icons.person, color: Colors.deepPurple),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              member.name,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}