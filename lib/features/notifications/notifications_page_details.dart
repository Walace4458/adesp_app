import 'package:flutter/material.dart';

class NotificationsPageDetails extends StatelessWidget{
  final String title;
  final String message;
  final String date;

  const NotificationsPageDetails({
    super.key,
    required this.title,
    required this.message,
    required this.date,

  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Notificação', style: Theme.of(context).textTheme.titleMedium,),
      ),
      body: Padding(padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Titulo
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8,),

            //Data

            Text(
              date,
              style: Theme.of(context).textTheme.bodySmall,
            ),

            const SizedBox(height: 8,),

            //Menssagem

            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
            )
          ],
        ),
      ),
    );
  }

}