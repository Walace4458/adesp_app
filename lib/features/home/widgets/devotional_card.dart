import 'package:flutter/material.dart';

class DevotionalCard extends StatelessWidget{

  final String title;
  final String preview;
  final String author;

  const DevotionalCard({
    super.key,
    required this.title,
    required this.preview,
    required this.author,  
  });

  @override
   Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium,),
        const SizedBox(height: 8,),
        Text(preview, style: Theme.of(context).textTheme.bodyMedium,),
        const SizedBox(height: 8,),
        Text(author, style: Theme.of(context).textTheme.bodySmall,),
        const SizedBox(height: 8,),

        Align(
          alignment: Alignment.centerRight,
        child: InkWell(child: Text("Ler Mais"), onTap: () => {},),
      ),],
      ),
      ),
    );
   }
}