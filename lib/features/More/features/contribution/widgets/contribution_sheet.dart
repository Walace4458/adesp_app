import 'package:flutter/material.dart';

class ContributionSheet extends StatefulWidget{
  final String type;
  const ContributionSheet({super.key, required this.type});

  @override
  State<ContributionSheet> createState() => _ContributionSheetState();
}

class _ContributionSheetState extends State<ContributionSheet> {
  int step = 1;
  int selectedValue = 10;
  bool recurring = false;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(
      bottom: MediaQuery.of(context).viewInsets.bottom,
    ),
      child: Container(
        padding: const EdgeInsets.all(20),

        child: step == 1 ? _buildStep1() : _buildStep2(),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          widget.type == "dizimo" ? "Dízimo" : "Oferta",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10,),

        const Text(
          "Escolha um valor para contribuir 🙏",
        ),

        const SizedBox(height: 20,),

        Wrap(
          spacing: 10,
          children: [10, 20, 50, 100].map((value) {
            final selected = selectedValue == value;

            return ChoiceChip(
              label: Text("R\$$value"), 
              selected: selected,
              onSelected: (_) {
                setState(() {
                  selectedValue = value;
                });
              },
            );
          }).toList(),
        ),

        const SizedBox(height: 20,),

        if(widget.type == "dizimo")
        SwitchListTile(
          title: const Text("Contribuição recorrente"),
          value: recurring,
          onChanged: (v) {
            setState(() {
              recurring = v;
            });
          },
        ),

        const SizedBox(height: 20,),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                step = 2;
              });
            }, 
            child: const Text("Continuar"),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2 () {
    return Column(
      mainAxisSize: MainAxisSize.min,

      children: [
        const Text(
          "Escaneie o QR Code",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 20,),

        Container(
          height: 200,
          width: 200,
          color: Colors.grey[300],
          child: const Center(child: Text("QR CODE"),),
        ),
        const SizedBox(height: 20,),

        Text("Valor: R\$$selectedValue"),

        const SizedBox(height: 10,),

        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Chave PIX copiada")),
            );
          }, 
          icon: const Icon(Icons.copy),
          label: const Text("Copiar chave PIX"),
        ),

        const SizedBox(height: 10,),
        Text(
          widget.type == "dizimo"
          ? "Obrigado pelo seu dízimo 🙏"
          : "Obriagado pela sua oferta ❤️",
        ),
      ],
    );
  }
}