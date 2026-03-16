import 'package:flutter/material.dart';

import '../../services/testimony_service.dart';
import '../../models/testimony.dart';
import 'submit_testimony_page.dart';
import 'testimony_card.dart';

class TestimoniesPage extends StatelessWidget {
  final TestimonyService service = TestimonyService();

  TestimoniesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Testemunhos"),
      ),

      body: FutureBuilder<List<Testimony>>(
        future: service.getTestimonies(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [

                  Icon(
                    Icons.auto_stories,
                    size: 60,
                    color: Colors.grey,
                  ),

                  SizedBox(height: 16),

                  Text(
                    "Ainda não há testemunhos",
                    style: TextStyle(fontSize: 18),
                  ),

                  SizedBox(height: 8),

                  Text(
                    "Seja o primeiro a compartilhar\nsua experiência com Deus.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );}

          final testimonies = snapshot.data!;

          return ListView.builder(
            itemCount: testimonies.length,
            itemBuilder: (context, index) {
              return TestimonyCard(
                testimony: testimonies[index],
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.edit),
        label: const Text("Enviar"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SubmitTestimonyPage(),
            ),
          );
        },
));}}