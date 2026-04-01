import 'package:flutter_application_1/features/More/features/cells/models/report_model.dart';

import '../models/cell_model.dart';
import '../models/interested_model.dart';
import '../models/member_model.dart';
import '../models/material_model.dart';

class CellService {

  // ================= CELLS =================

  static final List<CellModel> _cellsMock = [
    CellModel(
      id: '1',
      name: 'Célula Central Jovens',
      category: 'Jovens',
      leaderName: 'Lucas Silva',
      day: 'Quarta-feira',
      time: '19:30',
      address: 'Rua A, 123',
    ),
  ];

  static List<CellModel> getMyCells() {
    return _cellsMock;
  }

  // ================= INTERESTED =================

  static final Map<String, List<InterestedModel>> _interestedMock = {
    '1': [
      InterestedModel(
        id: 'i1',
        name: 'João',
        status: InterestedStatus.novo,
      ),
    ],
  };

  static List<InterestedModel> getInterested(String cellId) {
    return _interestedMock[cellId] ?? [];
  }

  static void addInterested({
    required String cellId,
    required InterestedModel interested,
  }) {
    _interestedMock.putIfAbsent(cellId, () => []);
    _interestedMock[cellId]!.add(interested);
  }

  // ================= MEMBERS =================

  static final Map<String, List<MemberModel>> _membersMock = {
    '1': [
      MemberModel(
        id: '1',
        name: 'Maria',
        birthDate: DateTime(2000, 3, 23),
      ),
      MemberModel(
        id: '2',
        name: 'Carlos',
        birthDate: DateTime(1998, 6, 10),
      ),
      MemberModel(
        id: '3',
        name: 'Ana',
        birthDate: DateTime(2001, 1, 5),
      ),
      MemberModel(
        id: '4',
        name: 'Pedro',
        birthDate: DateTime(1995, 9, 12),
      ),
    ],
  };

  static List<MemberModel> getMembers(String cellId) {
    return _membersMock[cellId] ?? [];
  }

  // ================= MATERIALS =================

  static final Map<String, List<MaterialModel>> _materialsMock = {
    '1': [
      MaterialModel(
        id: '1',
        title: 'Estudo da Semana',
        type: CellMaterialType.text,
        content: 'Conteúdo aqui...',
      ),
    ],
  };

  static List<MaterialModel> getMaterials(String cellId) {
    return _materialsMock[cellId] ?? [];
  }

  // ================= REPORTS =================

  static final Map<String, List<ReportModel>> _reportsMock = {
    '1': [
      ReportModel(
        id: 'r1',
        cellId: '1',
        date: DateTime.now().subtract(const Duration(days: 7)),
        newMembers: ['Lucas'],
        newVisitors: ['Visitante 1', 'Visitante 2'],
        presentMemberIds: ['1', '2'], // Maria e Carlos vieram
        description: 'Reunião forte',
        hadContribution: true,
        contributionValue: 100,
      ),
      ReportModel(
        id: 'r2',
        cellId: '1',
        date: DateTime.now().subtract(const Duration(days: 14)),
        newMembers: [],
        newVisitors: ['Visitante 3'],
        presentMemberIds: ['1'], // só Maria veio
        description: 'Reunião mais tranquila',
        hadContribution: false,
        contributionValue: 0,
      ),
    ],
  };

  static List<ReportModel> getReports(String cellId) {
    return _reportsMock[cellId] ?? [];
  }

  static void addReport(String cellId, ReportModel report) {
    _reportsMock.putIfAbsent(cellId, () => []);
    _reportsMock[cellId]!.insert(0, report);
  }
}