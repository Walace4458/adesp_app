import "package:flutter/material.dart";
import "midia_item.dart";

class MidiaDetailsPage extends StatelessWidget{
  final MidiaItem item;

  const MidiaDetailsPage({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalhes"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: AspectRatio(aspectRatio: 16/9,
            child: Image.network(
              item.thumbnail,
              fit: BoxFit.cover,
            ),
            ),
          ),
          Positioned.fill(child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black54,
                  Colors.transparent,
                ]
              )
            ),
          )
          ),
        ],
      ),
      Padding(padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.title,
          style.Theme.of(context).textTheme.headlineSmall?.copyWhit(fontWeight:FontWeight.bold),
          ),
          const SizedBox(height: 8,)
        ],
      ),
      ),
    );
  }
}