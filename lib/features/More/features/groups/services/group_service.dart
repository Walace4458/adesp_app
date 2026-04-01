import '../models/group_model.dart';

class GroupService {
  static final List<GroupModel> _groups = [
    GroupModel(
      id: '1', 
      name: 'Diáconos', 
      description: 'Serviço e apoio nos cultos', 
      role: 'Membro', 
      memberNames: ['Carlos', 'Pedro', 'Lucas'],
    ),
    GroupModel(
      id: '2', 
      name: 'Kids', 
      description: 'Ministério infantil', 
      role: 'Líder', 
      memberNames: ['Ana', 'Julia'],
    ),
  ];

  static List<GroupModel> getAll() => _groups;
}