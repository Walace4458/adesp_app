import '../models/reading_plan.dart';

class ReadingPlanRepository {
  List<ReadingPlan> getReadings() {
    return [
      ReadingPlan(
        id: '1',
        title: 'Novo Nascimento',
        day: 'Segunda',
        book: 'João',
        chapter: 3,
        description: 'Uma leitura sobre transformação espiritual.',
        comment: 'Reflita sobre o diálogo entre Jesus e Nicodemos.',
        progress: 0.3,
      ),
      ReadingPlan(
        id: '2',
        title: 'O Senhor é meu Pastor',
        day: 'Terça',
        book: 'Salmos',
        chapter: 23,
        description: 'Uma mensagem de confiança e cuidado.',
        comment: 'Leia pausadamente e medite em cada verso.',
        progress: 1.0,
        completed: true,
      ),
      ReadingPlan(
        id: '3',
        title: 'Vida no Espírito',
        day: 'Quarta',
        book: 'Romanos',
        chapter: 8,
        description: 'Uma leitura sobre esperança e identidade em Cristo.',
        comment: 'Observe a diferença entre carne e espírito.',
        progress: 0.5,
      ),
      ReadingPlan(
        id: '4',
        title: 'As Bem-aventuranças',
        day: 'Quinta',
        book: 'Mateus',
        chapter: 5,
        description: 'Ensinamentos fundamentais de Jesus.',
        comment: 'Veja o caráter do Reino de Deus apresentado por Cristo.',
      ),
      ReadingPlan(
        id: '5',
        title: 'A Armadura de Deus',
        day: 'Sexta',
        book: 'Efésios',
        chapter: 6,
        description: 'Fortalecimento espiritual para a caminhada cristã.',
        comment: 'Pense em como aplicar cada parte da armadura no dia a dia.',
      ),
    ];
  }
}