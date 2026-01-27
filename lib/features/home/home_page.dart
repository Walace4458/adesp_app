import 'package:flutter/material.dart';
import 'widgets/verse_card.dart';
import 'widgets/banner_card.dart';
import 'widgets/devotional_card.dart';
import 'widgets/videothumb_card.dart';
import 'widgets/today_agenda_card.dart';

class HomePage extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    var alturaTela = MediaQuery.of(context).size.height;
    var alturaBanner = alturaTela * 0.20;

    var larguraTela = MediaQuery.of(context).size.width;
    var cardWidth = larguraTela * 0.55;
    var thumbHeight = cardWidth * 9/16;

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            'ADESP', style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded),
              onPressed: (){}
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding (padding: EdgeInsets.all(16),
           child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: alturaBanner,
                child: ListView(scrollDirection: Axis.horizontal, padding: EdgeInsets.symmetric(horizontal: 8),
                children: [
                  BannerCard(imageUrl: "https://img.freepik.com/fotos-gratis/silhueta-do-homem-asiatico-consideravel-orando_1150-861.jpg?semt=ais_hybrid&w=740&q=80"),
                ],
              )
            ),
              SizedBox(height: 12,),
              VerseCard(title: "Versiculo do dia", 
                      verse: "Porque assim diz o Senhor aos homens de Judá e a Jerusalém: Preparai para vós o campo de lavoura, e não semeeis entre espinhos.", 
                      reference: "Jeremias 4:3"),
                      SizedBox(height: 12,),
                      DevotionalCard(
                        title: "Devocional do dia", 
                        preview: "E foi assim...", 
                        author: "Pr.Sandro Araujo"),
                      Text("Últimos vídeos", style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(height: thumbHeight + 60,
                      child: ListView(scrollDirection: Axis.horizontal, padding: EdgeInsets.symmetric(horizontal: 8),
                        children: [ 
                      VideothumbCard(thumbnailCard: "https://img.youtube.com/vi/f1bjR6SEPOo/maxresdefault.jpg",
                      title: "video 1"),
                      SizedBox(width: 12,),
                       VideothumbCard(thumbnailCard: "https://img.youtube.com/vi/f1bjR6SEPOo/maxresdefault.jpg",
                      title: "video 2"),
                       SizedBox(width: 12,),
                       VideothumbCard(thumbnailCard: "https://img.youtube.com/vi/f1bjR6SEPOo/maxresdefault.jpg",
                      title: "video 3"),
                      SizedBox(width: 12,),
                       VideothumbCard(thumbnailCard: "https://img.youtube.com/vi/f1bjR6SEPOo/maxresdefault.jpg",
                      title: "video 4"),
                        ],
                     ),
                      ),
                      SizedBox(height: 12,),
                      Text("Próxima programação",style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(height: 12,),
                      TodayAgendaCard(title: 'Agenda', dataLabel: "Quarta • 20:00", eventName: "Quarta Profetica")
            ],
          ),
          ),
        ),
      );
  }
}