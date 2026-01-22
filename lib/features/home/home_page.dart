import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Aprendendo Flutter'),
        ),
        body: SingleChildScrollView(
          child: Padding (padding: EdgeInsets.all(16),
           child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(child: Padding(padding: EdgeInsets.all(16),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Versiculo do Dia",
                        style: Theme.of(context).textTheme.titleMedium,),
                        Text("Porque isto era um estatuto para Israel, e uma lei do Deus de Jacó. Ordenou-o em José por testemunho, quando saíra pela terra do Egito, onde ouvi uma língua que não entendia.",
                        style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text("Salmos, 81 4:5",
                        style: Theme.of(context).textTheme.bodySmall,
                        )
                      ],
                    ),
              ),)
            ],
          ),
          ),
        ),
      );
  }
}