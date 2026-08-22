

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_pack/data/model/enum/gear_type_enum.dart';
import 'package:flutter_supabase_pack/domain/models/gear.dart';
import 'package:flutter_supabase_pack/presentation/features/gear_view/viewmodel/gear_cubit_2.dart';
import 'package:flutter_supabase_pack/presentation/features/gear_view/viewmodel/gear_state_2.dart'; // Sørg for at filstien er rett

class AddGearModal2 extends StatefulWidget {
  const AddGearModal2({super.key});

  @override
  State<AddGearModal2> createState() => _AddGearModalState();
}

class _AddGearModalState extends State<AddGearModal2> {
  String name = '';
  String brand = '';
  GearType selectedType = GearType.other; 
  int grams = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            value: selectedType, // Rettet fra initialValue til value
            decoration: const InputDecoration(labelText: 'Kategori / Type'),
            items: GearType.values.map((GearType type) {
              return DropdownMenuItem<GearType>(
                value: type,
                child: Text(type.name),
              );
            }).toList(),
            onChanged: (GearType? newValue) {
              if (newValue != null) {
                setState(() {
                  selectedType = newValue;
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
          
          // Bruker en BlocBuilder for å deaktivere knappen eller vise lasteeffekt under lagring
          BlocBuilder<GearCubit2, GearStateSingle>(
            builder: (context, state) {
              final isAdding = state.status == GearStatus.adding;

              return ElevatedButton(
                onPressed: isAdding 
                  ? null // Deaktiverer knappen mens den lagrer i Supabase
                  : () {
                      final newGear = Gear(
                        id: null,
                        createdAt: null,
                        name: name,
                        brand: brand,
                        grams: grams,
                        description: '',
                        type: selectedType,
                      );

                      // Kaller den nye GearCubit2
                      context.read<GearCubit2>().addGear(newGear);
                      
                      // MERK: Navigator.pop(context) er fjernet herfra.
                      // Den håndteres nå automatisk av BlocConsumer i GearScreen!
                    },
                child: isAdding 
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Lagre utstyr'),
              );
            },
          ),
        ],
      ),
    );
  }
}
