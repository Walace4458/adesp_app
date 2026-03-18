import '../models/cell_model.dart';

class CellService {
  static Future<List<CellModel>> getMyCells() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      CellModel(
        id: "1",
        name: "Célula Jovem",
        leader: "João",
        day: "Sexta",
        time: "19:30",
        address: "Rua A, 123",
      ),
      CellModel(
        id: "2",
        name: "Célula Família",
        leader: "Maria",
        day: "Quarta",
        time: "20:00",
        address: "Rua B, 456",
      ),
    ];
  }
}