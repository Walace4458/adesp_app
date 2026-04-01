import 'package:flutter/material.dart';

import '../models/followup_model.dart';
import '../services/followup_service.dart';
import '../widgets/followup_tile.dart';

class FollowUpPage extends StatefulWidget {
  const FollowUpPage({super.key});

  @override
  State<FollowUpPage> createState() => _FollowUpPageState();
}

class _FollowUpPageState extends State<FollowUpPage> {
  List<FollowUpModel> pending = [];
  List<FollowUpModel> done = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    pending = FollowUpService.getPending();
    done = FollowUpService.getDone();
  }

  void _refresh() {
    setState(() {
      _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Follow-ups"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: (pending.isEmpty && done.isEmpty)
            ? const Center(child: Text("Nenhum acompanhamento ainda"))
            : ListView(
                children: [
                  // =========================
                  // 🔴 PENDENTES
                  // =========================
                  const Text(
                    "Pendentes",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  if (pending.isEmpty)
                    const Text("Nenhum pendente"),

                  ...pending.map((f) => FollowUpTile(
                        followUp: f,
                        onUpdate: _refresh,
                      )),

                  const SizedBox(height: 24),

                  // =========================
                  // 🟢 CONCLUÍDOS
                  // =========================
                  const Text(
                    "Concluídos",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  if (done.isEmpty)
                    const Text("Nenhum concluído"),

                  ...done.map((f) => FollowUpTile(
                        followUp: f,
                        onUpdate: _refresh,
                      )),
                ],
              ),
      ),
    );
  }
}