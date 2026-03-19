import 'package:flutter/material.dart';

import '../models/cell_model.dart';
import '../models/member_model.dart';
import '../models/interested_model.dart';
import '../models/material_model.dart';

import '../services/cell_service.dart';

import '../widget/section_tile.dart';
import '../widget/member_tile.dart';
import '../widget/interested_tile.dart';
import '../widget/action_button.dart';

class CellDetailsPage extends StatelessWidget {
  final CellModel cell;

  const CellDetailsPage({
    super.key,
    required this.cell,
  });

  @override
  Widget build(BuildContext context) {
    final members = CellService.getMembers(cell.id);
    final interested = CellService.getInterested(cell.id);
    final materials = CellService.getMaterials(cell.id); // ✅ corrigido

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildHeader(context),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _cardWrapper(_buildInterested(interested)),
                  _cardWrapper(_buildBirthdays(members)),
                  _cardWrapper(_buildMaterials(materials)),
                  _cardWrapper(_buildActions()),
                  const SizedBox(height: 30),
                ],
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
      elevation: 0,
      backgroundColor: Colors.deepPurple,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        title: Text(
          cell.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5F2C82), Color(0xFF49A09D)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 100, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoChip(Icons.group, cell.category),
                const SizedBox(height: 8),
                _infoChip(Icons.schedule, "${cell.day} • ${cell.time}"),
                const SizedBox(height: 8),
                _infoChip(Icons.location_on, cell.address),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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

  // ================= WRAPPER =================

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

  Widget _buildInterested(List<InterestedModel> interested) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle("Interessados"),
        const SizedBox(height: 8),
        ...interested.map((i) => InterestedTile(i)).toList(),
      ],
    );
  }

  // ================= BIRTHDAYS =================

  Widget _buildBirthdays(List<MemberModel> members) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle("Aniversariantes 🎉"),
        const SizedBox(height: 8),
        ...members.map((m) => MemberTile(m)).toList(),
      ],
    );
  }

  // ================= MATERIALS =================

  Widget _buildMaterials(List<MaterialModel> materials) {
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

          return ListTile(
            leading: Icon(icon),
            title: Text(m.title),
            onTap: () {},
          );
        }).toList(),
      ],
    );
  }

  // ================= ACTIONS =================

    Widget _buildActions() {
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
                onTap: () {},
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ActionButton(
                icon: Icons.check_circle_rounded,
                label: "Presença",
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
                icon: Icons.share_rounded,
                label: "Compartilhar",
                onTap: () {},
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ActionButton(
                icon: Icons.bar_chart_rounded,
                label: "Relatório",
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}