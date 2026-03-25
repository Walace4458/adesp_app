import 'package:flutter/material.dart';

import '../models/cell_model.dart';
import '../models/member_model.dart';
import '../models/interested_model.dart';
import '../models/material_model.dart';
import '../pages/report_history_page.dart';
import '../pages/dashboard_page.dart'; // 🔥 NOVO

import '../services/cell_service.dart';

import '../widget/section_tile.dart';
import '../widget/member_tile.dart';
import '../widget/interested_tile.dart';
import '../widget/action_button.dart';

import 'add_person_page.dart';
import 'report_page.dart';

class CellDetailsPage extends StatefulWidget {
  final CellModel cell;

  const CellDetailsPage({
    super.key,
    required this.cell,
  });

  @override
  State<CellDetailsPage> createState() => _CellDetailsPageState();
}

class _CellDetailsPageState extends State<CellDetailsPage> {
  late List<MemberModel> members;
  late List<InterestedModel> interested;
  late List<MaterialModel> materials;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    members = CellService.getMembers(widget.cell.id);
    interested = CellService.getInterested(widget.cell.id);
    materials = CellService.getMaterials(widget.cell.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildHeader(context),

          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 700),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _cardWrapper(_buildInterested()),
                      _cardWrapper(_buildMembers()),
                      _cardWrapper(_buildMaterials()),
                      _cardWrapper(_buildActions(context)),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // ================= HEADER =================

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: const BackButton(color: Colors.white),
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final isCollapsed = constraints.maxHeight < 120;

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5F2C82), Color(0xFF49A09D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  if (!isCollapsed)
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.cell.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _infoChip(Icons.group, widget.cell.category),
                          const SizedBox(height: 6),
                          _infoChip(Icons.schedule,
                              "${widget.cell.day} • ${widget.cell.time}"),
                          const SizedBox(height: 6),
                          _infoChip(
                              Icons.location_on, widget.cell.address),
                        ],
                      ),
                    ),

                  if (isCollapsed)
                    Positioned(
                      left: 56,
                      bottom: 16,
                      child: Text(
                        widget.cell.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 18),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white70),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // ================= CARD =================

  Widget _cardWrapper(Widget child) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  // ================= INTERESTED =================

  Widget _buildInterested() {
    if (interested.isEmpty) {
      return const Text("Nenhum interessado ainda");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle("Interessados"),
        const SizedBox(height: 8),
        ...interested.map((i) => InterestedTile(i)).toList(),
      ],
    );
  }

  // ================= MEMBERS =================

  Widget _buildMembers() {
    if (members.isEmpty) {
      return const Text("Nenhum membro ainda");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle("Membros"),
        const SizedBox(height: 8),
        ...members.map((m) => MemberTile(member: m)).toList(),
      ],
    );
  }

  // ================= MATERIALS =================

  Widget _buildMaterials() {
    if (materials.isEmpty) {
      return const Text("Nenhum material disponível");
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle("Material de Apoio"),
        const SizedBox(height: 8),
        ...materials.map((m) {
          IconData icon;

          switch (m.type) {
            case CellMaterialType.pdf:
              icon = Icons.picture_as_pdf_rounded;
              break;
            case CellMaterialType.link:
              icon = Icons.link_rounded;
              break;
            case CellMaterialType.text:
              icon = Icons.text_snippet_rounded;
              break;
          }

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Icon(icon, color: Colors.deepPurple),
              title: Text(
                m.title,
                style: const TextStyle(color: Colors.black),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          );
        }).toList(),
      ],
    );
  }

  // ================= ACTIONS =================

  Widget _buildActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle("Ações do Líder"),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: ActionButton(
                icon: Icons.person_add_rounded,
                label: "Adicionar",
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddPersonPage(
                        cellId: widget.cell.id,
                      ),
                    ),
                  );

                  setState(() => _loadData());
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ActionButton(
                icon: Icons.share_rounded,
                label: "Compartilhar",
                onTap: () {},
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            Expanded(
              child: ActionButton(
                icon: Icons.bar_chart_rounded,
                label: "Relatórios",
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReportHistoryPage(
                        cellId: widget.cell.id,
                      ),
                    ),
                  );

                  setState(() => _loadData());
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ActionButton(
                icon: Icons.dashboard_rounded, // 🔥 NOVO
                label: "Dashboard",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DashboardPage(
                        cellId: widget.cell.id,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}