import 'package:flutter/material.dart';

class ContributionSection extends StatefulWidget {
  final Function(bool hasContribution, double? value) onChanged;

  const ContributionSection({
    super.key,
    required this.onChanged,
  });

  @override
  State<ContributionSection> createState() => _ContributionSectionState();
}

class _ContributionSectionState extends State<ContributionSection> {
  bool hasContribution = false;
  final _controller = TextEditingController();

  void _notify() {
    final value = double.tryParse(_controller.text.replaceAll(',', '.'));

    widget.onChanged(
      hasContribution,
      hasContribution ? value : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: hasContribution, 
              onChanged: (value) {
                setState(() {
                  hasContribution = value!;
                  _notify();
                });
              },
            ),

            const Text("Recebeu contribuição?"),
          ],
        ),

        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: hasContribution ? TextField(
            key: const ValueKey("input"),
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Valor (R\$)",
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => _notify(),
          )
          : const SizedBox.shrink(),
        )
      ],
    );
  }
}