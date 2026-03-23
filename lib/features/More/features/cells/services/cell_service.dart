import '../models/cell_model.dart';
import '../models/interested_model.dart';
import '../models/member_model.dart';
import '../models/material_model.dart';

class CellService {

  // ================= MOCK CELLS =================

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
    CellModel(
      id: '2',
      name: 'Célula Família',
      category: 'Mistos',
      leaderName: 'Marcos Oliveira',
      day: 'Sexta-feira',
      time: '20:00',
      address: 'Rua B, 456',
    ),
  ];

  static List<CellModel> getMyCells() {
    return _cellsMock;
  }

  // ================= INTERESTED =================

  static final Map<String, List<InterestedModel>> _interestedMock = {
    '1': [
      InterestedModel(
        id: '1',
        name: 'João',
        status: InterestedStatus.novo,
      ),
    ],
  };

  static List<InterestedModel> getInterested(String cellId) {
    return _interestedMock[cellId] ?? [];
  }

  // 🔥 CORRIGIDO (AGORA NOMEADO)
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

    static void togglePresence(String cellId, String memberId) {
    final members = _membersMock[cellId];

    if (members == null) return;

    final index = members.indexWhere((m) => m.id == memberId);

    if (index == -1) return;

    members[index].isPresent = !members[index].isPresent;
  }
}

