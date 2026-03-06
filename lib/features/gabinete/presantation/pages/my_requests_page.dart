import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/gabinete_controller.dart';
import '../../models/gabinete_enums.dart';

class MyRequestsPage extends StatelessWidget {
  final String userId;

  const MyRequestsPage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<GabineteController>();
    final requests = controller.state.myRequests;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus atendimentos'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.loadMyRequests(userId);
        },
        child: ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final r = requests[index];

            return Card(
              margin: const EdgeInsets.all(12),
              child: ListTile(
                title: Text(r.categoryId),
                subtitle: Text(
                  "${r.slot.start.day}/${r.slot.start.month} - ${r.slot.start.hour}:${r.slot.start.minute.toString().padLeft(2,'0')}",
                ),
                trailing: _statusChip(r.status),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _statusChip(GabineteRequestStatus status) {
    switch (status) {
      case GabineteRequestStatus.pendingAdminApproval:
        return const Chip(label: Text("Aguardando"));
      case GabineteRequestStatus.confirmed:
        return const Chip(label: Text("Confirmado"));
      case GabineteRequestStatus.cancelled:
        return const Chip(label: Text("Cancelado"));
      case GabineteRequestStatus.completed:
        return const Chip(label: Text("Finalizado"));
      case GabineteRequestStatus.expired:
        return const Chip(label: Text("Expirado"));
    }
  }
}