import '../models/cell_model.dart';
import '../models/member_model.dart';
import '../models/interested_model.dart';
import '../models/material_model.dart';

class CellService {
  /// Cells
  static List<CellModel> getMyCells() {
    return [
      CellModel(
        id: '1', 
        name: 'Célula Vida', 
        category: "Jovens", 
        leaderName: "João Silva", 
        day: "Quarta-Feira", 
        time: '19:30', 
        address: "Rua das Flores, 123",
      ),
      CellModel(
        id: '2', 
        name: 'Célula Fé', 
        category: "Mista", 
        leaderName: "Maria Souza", 
        day: "Sexta-feira", 
        time: '20:00', 
        address: "Av. Central, 456",
      ),
    ];
  }

  /// Members
  static List<MemberModel> getMembers(String cellId) {
    return [
      MemberModel(
        id: '1', 
        name: 'Carlos', 
        birthDate: DateTime(2000, 3, 20)
      ),
      MemberModel(
        id: '2', 
        name: 'Ana', 
        birthDate: DateTime(1998, 3, 25),
      ),
    ];
  }

  ///Interested
  static List<InterestedModel> getInterested(String cellId) {
    return [
      InterestedModel(
        id: '1', 
        name: 'Lucas', 
        status: InterestedStatus.novo,
      ),
      InterestedModel(
        id: '2', 
        name: 'Fernanda', 
        status: InterestedStatus.visitou,
      ),
      InterestedModel(
        id: '3', 
        name: 'Bruno', 
        status: InterestedStatus.membro,
      ),
    ];
  }

  ///Materials
  static List<MaterialModel> getMaterials(String cellId) {
    return [
      MaterialModel(
        id: '1', 
        title: 'Estudo da Semana', 
        type: CellMaterialType.pdf, 
        content: 'link_pdf_aqui',
      ),
      MaterialModel(
        id: '2', 
        title: 'Vídeo YouTube', 
        type: CellMaterialType.link, 
        content: 'https://youtube.com',
      ),
      MaterialModel(
        id: '3', 
        title: 'Resumo', 
        type: CellMaterialType.text, 
        content: 'Texto do estudo...',
      ),
    ];
  }
}