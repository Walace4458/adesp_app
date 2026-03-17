import 'package:flutter/material.dart';

import '../widgets/contribution_card.dart';
import '../widgets/contribution_sheet.dart';

class ContributionPage extends StatelessWidget{
  const ContributionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contribuição"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ContributionCard(
              title: "Dízimo",
              imageUrl: "https://via.placeholder.com/300x150", 
              onTap: () {
                showModalBottomSheet(context: context, 
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20),),
                ),
                builder: (_) => const ContributionSheet(type: "dizimo"),
              );
              },
            ),

            const SizedBox(height: 16,),

            ContributionCard(
              title: "Oferta",
              imageUrl: "https://via.placeholder.com/300x150",
              onTap: () {
                showModalBottomSheet(context: context, 
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20),),
                ),
                builder: (_) => const ContributionSheet(type: "oferta"),
              );
              }, 
            ),

          ],
        ),
      ),
    );
  }
}