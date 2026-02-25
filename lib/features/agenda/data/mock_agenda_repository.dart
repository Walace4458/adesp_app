import 'package:flutter_application_1/features/agenda/models/agenda_event.dart';
import 'agenda_repository.dart';

class MockAgendaRepository implements AgendaRepository{
  
  @override
  Future<List<AgendaEvent>> fetchEvents() async {
    await Future.delayed(const Duration(milliseconds: 700));

    final now = DateTime.now();

    DateTime at(int daysFromNow, int hour, int minute) {
      final base = DateTime(now.year, now.month, now.day).add(Duration(days: daysFromNow));
      return DateTime(base.year, base.month, base.day, hour, minute);
    }


    return [
      AgendaEvent(
        id: 'e1', 
        title: 'Conferência de Avivamento', 
        startAt: at(2,19,30), 
        location: 'ADESP - Sede', 
        description: 'Uma noite especial de louvor e palavra', 
        category: AgendaCategory.evento,
        isFeatured: true,
        bannerUrl: null,
        ),
        AgendaEvent(
        id: 'e2', 
        title: 'Culto da Família', 
        startAt: at(0, 19, 0), 
        location: 'ADESP - Sede', 
        description: 'Traga sua família e venha adorar com a gente', 
        category: AgendaCategory.culto,
        isFeatured: true,
        ),
        AgendaEvent(
        id: 'e3', 
        title: 'Célula - Zona Norte', 
        startAt: at(1, 20, 0), 
        location: 'Casa do Irmão João', 
        description: 'Comunhão, palavra e oração', 
        category: AgendaCategory.celula,
        ),
      AgendaEvent(
        id: 'e4',
        title: 'Jovens - Quarta Profética',
        startAt: at(3, 19, 30),
        location: 'ADESP - Sede',
        description: 'Noite dos jovens.',
        category: AgendaCategory.jovens,
      ),
      AgendaEvent(
        id: 'e5',
        title: 'Ensaio do Louvor',
        startAt: at(4, 20, 0),
        location: 'ADESP - Sala de Música',
        description: 'Equipe do louvor.',
        category: AgendaCategory.ensaio,
      ),
      AgendaEvent(
        id: 'e6',
        title: 'Culto de Domingo (semana passada)',
        startAt: at(-6, 19, 0),
        location: 'ADESP - Sede',
        description: 'Evento de teste da semana anterior.',
        category: AgendaCategory.culto,
      ),
    ];
  }
}