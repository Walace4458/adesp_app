import "package:flutter/material.dart";

class BannerCard extends StatelessWidget{

  final String imageUrl;

  const BannerCard ({
    super.key,
    required this.imageUrl,
  });

@override
  Widget build(BuildContext context) {
    var alturaTela = MediaQuery.of(context).size.height;
    var alturaBanner = alturaTela * 0.20;
    return Card(
      child: InkWell(
        child: Container(
          height: alturaBanner,
          width: double.infinity,
          decoration: BoxDecoration(image: DecorationImage(image: 
         NetworkImage(imageUrl),
         fit: BoxFit.cover,
         ))),
        ),
      );
}
}