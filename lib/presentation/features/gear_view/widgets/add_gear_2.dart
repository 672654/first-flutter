

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_supabase_pack/data/model/enum/gear_type_enum.dart';
import 'package:flutter_supabase_pack/domain/models/gear.dart';
import 'package:flutter_supabase_pack/presentation/features/gear_view/viewmodel/gear_cubit_2.dart';
import 'package:flutter_supabase_pack/presentation/features/gear_view/viewmodel/gear_state_2.dart'; // Sørg for at filstien er rett

class AddGearModal2 extends StatefulWidget {
  final Gear? gearToEdit;
  const AddGearModal2({super.key, this.gearToEdit});

  @override
  State<AddGearModal2> createState() => _AddGearModalState();
}

class _AddGearModalState extends State<AddGearModal2> {


  late final TextEditingController _nameController;
  late final TextEditingController _brandController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _gramsController;
  late GearType _selectedType;

  bool get _isEditing => widget.gearToEdit != null;

  @override
  void initState() {
    super.initState();
    
      _nameController = TextEditingController(text: widget.gearToEdit?.name ?? '');
      _brandController = TextEditingController(text: widget.gearToEdit?.brand ?? '');
      _descriptionController = TextEditingController(text: widget.gearToEdit?.description ?? '');
      _selectedType = widget.gearToEdit?.type ?? GearType.other;
      _gramsController = TextEditingController(text: widget.gearToEdit?.grams.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _gramsController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

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
          Text(
            _isEditing ? 'Rediger utstyr' : 'Nytt utstyr',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Navn'),
           
          ),
          TextField(
            controller: _brandController,
            decoration: const InputDecoration(labelText: 'Merke'),
          ),

          DropdownButtonFormField<GearType>(
            value: _selectedType,
            decoration: const InputDecoration(labelText: 'Kategori'),
            items: GearType.values.map((GearType type) {
              return DropdownMenuItem<GearType>(
                value: type,
                child: Text(type.name),
              );
            }).toList(),
            onChanged: (GearType? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedType = newValue;
                });
              }
            },
          ),

          TextField(
            controller: _gramsController,
            decoration: const InputDecoration(labelText: 'Vekt (gram)'),
            keyboardType: TextInputType.number,
            
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
                        id: widget.gearToEdit?.id, // Hvis vi redigerer, behold id-en
                        createdAt: widget.gearToEdit?.createdAt,
                        name: _nameController.text,
                        brand: _brandController.text,
                        grams: int.tryParse(_gramsController.text) ?? 0,
                        description: _descriptionController.text,
                        type: _selectedType,
                      );

                      if (_isEditing){
                        context.read<GearCubit2>().updateGear(newGear);
                      } else {
                        context.read<GearCubit2>().addGear(newGear);
                      }
                      
                    },
                child: isAdding 
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Lagre'),
              );
            },
          ),
        ],
      ),
    );
  }
}
