import 'package:flutter/material.dart';

import '../../cells/models/member_model.dart';

// 🔥 IMPORTS NECESSÁRIOS
import '../../followup/models/followup_model.dart';
import '../../followup/services/followup_service.dart';

class InsightBottomSheet extends StatelessWidget {
  final String title;
  final List<MemberModel> members;
  final List<String> names; // 🔥 visitantes

  const InsightBottomSheet({
    super.key,
    required this.title,
    required this.members,
    this.names = const [],
  });

  @override
  Widget build(BuildContext context) {
    final hasMembers = members.isNotEmpty;
    final hasNames = names.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView( // 🔥 evita overflow
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 TÍTULO
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // 🔥 CASO VAZIO
            if (!hasMembers && !hasNames)
              const Text(
                "Nenhuma pessoa encontrada",
                style: TextStyle(color: Colors.white70),
              ),

            // =========================
            // 👥 MEMBROS
            // =========================
            ...members.map((m) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading:
                        const Icon(Icons.person, color: Colors.white70),

                    title: Text(
                      m.name,
                      style: const TextStyle(color: Colors.white),
                    ),

                    trailing: TextButton(
                      onPressed: () {
                        FollowUpService.add(
                          FollowUpModel(
                            id: DateTime.now().toString(),
                            memberId: m.id,
                            memberName: m.name,
                            reason: title,
                            createdAt: DateTime.now(),
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("Follow-up criado para ${m.name}"),
                          ),
                        );
                      },
                      child: const Text(
                        "Acompanhar",
                        style: TextStyle(
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                    ),
                  ),
                )),

            // =========================
            // 👤 VISITANTES
            // =========================
            ...names.map((n) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.person_outline,
                      color: Colors.white70,
                    ),
                    title: Text(
                      n,
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "$n pode ser adicionado como membro depois",
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        "Ver",
                        style: TextStyle(color: Colors.greenAccent),
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}