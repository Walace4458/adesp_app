import 'package:flutter/material.dart';

class VideothumbCard extends StatelessWidget{
  final String thumbnailCard;
  final String title;
  final VoidCallback? onTap;

  const VideothumbCard ({
    super.key,
    required this.thumbnailCard,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var larguraTela = MediaQuery.of(context).size.width;
    var cardWidth = larguraTela * 0.55;
    var thumbHeight = cardWidth * 9/16;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: cardWidth,
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12)
                ) , 
              child: Container(
                height: thumbHeight,
                decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(thumbnailCard),
                fit: BoxFit.cover)),
              )),
              Padding(padding: EdgeInsetsGeometry.all(12),
              child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}