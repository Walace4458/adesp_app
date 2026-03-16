import 'package:flutter/material.dart';

import '../../models/testimony.dart';

class TestimonyCard extends StatefulWidget {
  final Testimony testimony;

  const TestimonyCard({
    super.key,
    required this.testimony,
  });

  @override
  State<TestimonyCard> createState() => _TestimonyCardState();
}

class _TestimonyCardState extends State<TestimonyCard> {
  bool liked = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,

      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              /// Avatar + Nome
              Row(
                children: [

                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.2),

                    child: Text(
                      widget.testimony.name[0].toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Text(
                    widget.testimony.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// Mensagem
              Text(
                widget.testimony.message,
                style: const TextStyle(fontSize: 14),
              ),

              const SizedBox(height: 10),

              /// Data
              Text(
                "${widget.testimony.date.day}/${widget.testimony.date.month}/${widget.testimony.date.year}",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 8),

              /// Curtir
              Row(
                children: [

                  IconButton(
                    icon: Icon(
                      liked ? Icons.favorite : Icons.favorite_border,
                      color: liked ? Colors.red : null,
                    ),
                    onPressed: () {
                      setState(() {
                        liked = !liked;

                        if (liked) {
                          widget.testimony.likes++;
                        } else {
                          widget.testimony.likes--;
                        }
                      });
                    },
                  ),

                  Text("${widget.testimony.likes} curtidas"),

                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}