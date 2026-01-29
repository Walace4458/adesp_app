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

    var banners = ["https://img.youtube.com/vi/f1bjR6SEPOo/maxresdefault.jpg", "https://picsum.photos/536/354"];
    return Scaffold(
        body: SingleChildScrollView(
          child: Padding (padding: EdgeInsets.all(16),
           child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                  if (banners.length == 1) Center(child: BannerCard(imageUrl: banners[0]))
                  else SizedBox( 
                        height: alturaBanner, 
                        child: 
                    ListView(
                        scrollDirection: Axis.horizontal, 
                        padding: EdgeInsets.symmetric(horizontal: 14),
                        children: [
                          BannerCard(imageUrl: banners[0]),
                          SizedBox(width: 13),
                          BannerCard(imageUrl: banners[1]),
                        ],
                        ),
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
        ],  ),
          ),
        ),
      );
  }
}