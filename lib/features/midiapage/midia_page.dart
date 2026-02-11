import 'package:flutter/material.dart';

class MidiaPage extends StatefulWidget {
  const MidiaPage({super.key});

  @override
  State<MidiaPage> createState() => _MidiaPageState();
}

class _MidiaPageState extends State<MidiaPage> {
  bool isLoading = true;
  List<String> videos = [];

  @override
  void initState(){
    super.initState();
    loadVideos();
  }

  void loadVideos() async{ 
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      videos = [
        "Culto Domingo - Mensagem Poderosa",
        "Louvor Especial - Noite de Adoração",
      ];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        if (isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (videos.isEmpty) {
          return const Center(
            child: Text("Nenhum vídeo disponível"),
          );
        }
        return ListView.builder(padding: const EdgeInsets.all(16),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return Card(
            child: Padding(padding: const EdgeInsets.all(16),
            child: Text(
              videos[index],
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ),
          );
        }
        );
      }),
    );
  }
}