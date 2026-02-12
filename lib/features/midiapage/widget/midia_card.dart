import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/midiapage/models/midia_item.dart';

enum MidiaCardVariant { featured, normal, compact }

class MidiaCard extends StatelessWidget {
  final MidiaItem item;
  final VoidCallback? onTap;
  final MidiaCardVariant variant;

  const MidiaCard({
    super.key,
    required this.item,
    this.onTap,
    required this.variant,
  });

  @override
  Widget build(BuildContext context) {

    double width;

    switch (variant) {
      case MidiaCardVariant.featured:
        width = 250;
        break;
      case MidiaCardVariant.normal:
        width = 210;
        break;
      case MidiaCardVariant.compact:
        width = 180;
        break;
    }

    return SizedBox(
      width: width,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Thumbnail
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  item.thumbnail,
                  fit: BoxFit.cover,
                ),
              ),

              // Texto
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
