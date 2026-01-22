import 'package:flutter/material.dart';

class VerseCard extends StatelessWidget {
  final String title;
  final String verse;
  final String reference;
  
  const VerseCard({ 
    super.key,
    required this.title,
    required this.verse,
    required this.reference,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium,),
        const SizedBox(height: 8,),
        Text(verse, style: Theme.of(context).textTheme.bodyMedium,),
        const SizedBox(height: 8,),
        Text(reference, style: Theme.of(context).textTheme.bodySmall,),
      ],
      ),
      ),
    );
  }
}
