import "package:flutter/material.dart";

class BannerCard extends StatelessWidget{

  final String imageUrl;
  final VoidCallback? onTap;

  const BannerCard ({
    super.key,
    required this.imageUrl,
    this.onTap,
  });

@override
  Widget build(BuildContext context) {
    var alturaTela = MediaQuery.of(context).size.height;
    var larguraTela = MediaQuery.of(context).size.width;
    var bannerWidth = larguraTela * 0.85;
    var alturaBanner = alturaTela * 0.20;
    return Card(
      child: InkWell(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
          child: Container(
          height: alturaBanner,
          width: bannerWidth,
          decoration: BoxDecoration(image: DecorationImage(image: 
         NetworkImage(imageUrl),
         fit: BoxFit.cover,
         )))),
        ),
      );
}
}