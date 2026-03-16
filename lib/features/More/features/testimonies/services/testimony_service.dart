import '../models/testimony.dart';

class TestimonyService {
  Future<List<Testimony>> getTestimonies() async {
    await Future.delayed(Duration(milliseconds: 300));

    return [
      Testimony(
        id: '1', 
        name: 'Maria', 
        message: 'Deus Mudou minha vida completamente. Sou muito grata por tudo.', 
        date: DateTime(2025, 5, 10),
        likes: 3,
      ),

      Testimony(
        id: '2', 
        name: 'João', 
        message: 'Passei por momentos difíceis, mas Deus sempre esteve comigo.', 
        date: DateTime(2024, 6, 2),
        likes: 20,
      ),

      Testimony(
        id: '3', 
        name: 'Ana', 
        message: 'Recebi uma grande benção na minha família. Deus é fiel!', 
        date: DateTime(2024, 7, 14),
        likes: 0,
      ),
    ];
  }
}