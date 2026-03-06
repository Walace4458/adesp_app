import 'package:flutter/material.dart';
import '../../../models/more_option.dart';

class MoreOptionTile extends StatelessWidget{
  final MoreOption option;

  const MoreOptionTile({super.key, required this.option,});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(option.icon),
      title: Text(option.title),
      trailing: const Icon(Icons.arrow_forward_ios_rounded),
      onTap: () {
        Navigator.push(
            context, 
            MaterialPageRoute(builder: (_) => option.page),
          );
      },
    );
  }
}