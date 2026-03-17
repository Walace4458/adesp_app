import 'package:flutter/material.dart';

class ProfileProgress extends StatelessWidget{
  final double value;
  const ProfileProgress({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("${(value * 100).toInt()}% completo"),
        const SizedBox(height: 5,),
        LinearProgressIndicator(value: value,),
      ],
    );
  }
}