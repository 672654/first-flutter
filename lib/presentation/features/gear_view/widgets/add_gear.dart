import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_pack/data/model/enum/gear_type_enum.dart';
import 'package:flutter_supabase_pack/domain/models/gear.dart';
import 'package:flutter_supabase_pack/presentation/features/gear_view/viewmodel/gear_cubit.dart';

class AddGearModal extends StatefulWidget {
  const AddGearModal({super.key});

  @override
  State<AddGearModal> createState() => _AddGearModalState();
}

class _AddGearModalState extends State<AddGearModal> {
  String name = '';
  String brand = '';
  GearType selectedType = GearType.other; // Standardverdi for type
  int grams = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Sørger for at modalen skyves opp når tastaturet dukker opp
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Nytt utstyr',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(labelText: 'Navn'),
            onChanged: (val) => name = val,
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Merke'),
            onChanged: (val) => brand = val,
          ),

          DropdownButtonFormField<GearType>(
            initialValue: selectedType,
            decoration: const InputDecoration(labelText: 'Kategori / Type'),
            // Mapper over alle verdiene i enumen din til dropdown-elementer
            items: GearType.values.map((GearType type) {
              return DropdownMenuItem<GearType>(
                value: type,
                child: Text(type.name), // Viser f.eks. "backpack" eller "tent" som tekst
              );
            }).toList(),
            onChanged: (GearType? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedType = newValue; // Oppdaterer valgt type i staten
                });
              }
            },
          ),

          TextField(
            decoration: const InputDecoration(labelText: 'Vekt (gram)'),
            keyboardType: TextInputType.number,
            onChanged: (val) => grams = int.tryParse(val) ?? 0,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // 1. Opprett objektet (bytt ut med din eksakte modell/konstruktør)
              final newGear = Gear(
                id: null,
                createdAt: null,
                name: name,
                brand: brand,
                grams: grams,
                description: '',
                type: selectedType
              );

              // 2. Kall cubit via context (siden vi brukte BlocProvider.value)
              context.read<GearCubit>().addGear(newGear);

              // 3. Lukk modalen umiddelbart
              Navigator.pop(context);
            },
            child: const Text('Lagre utstyr'),
          ),
        ],
      ),
    );
  }
}
