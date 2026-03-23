import 'package:flutter/material.dart';
import '../models/member_model.dart';
import '../services/cell_service.dart';

class MemberTile extends StatelessWidget {
  final MemberModel member;
  final String cellId;
  final VoidCallback onUpdated;

  const MemberTile({
    super.key,
    required this.member,
    required this.cellId,
    required this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final isPresent = member.isPresent;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        CellService.togglePresence(cellId, member.id);
        onUpdated();

        // 🔥 feedback rápido
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isPresent
                  ? "${member.name} marcado como ausente"
                  : "${member.name} marcado como presente",
            ),
            duration: const Duration(milliseconds: 700),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isPresent ? Colors.green.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPresent
                ? Colors.green
                : Colors.grey.shade300,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            // ÍCONE
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isPresent
                    ? Colors.green
                    : Colors.grey.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isPresent
                    ? Icons.check
                    : Icons.person,
                size: 18,
                color: isPresent
                    ? Colors.white
                    : Colors.grey.shade600,
              ),
            ),

            const SizedBox(width: 12),

            // NOME
            Expanded(
              child: Text(
                member.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.black,
                ),
              ),
            ),

            // STATUS
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: isPresent
                  ? Container(
                      key: const ValueKey("present"),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Presente",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : Container(
                      key: const ValueKey("absent"),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Ausente",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}