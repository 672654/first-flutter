
import 'package:flutter/material.dart';

// Definerer de fire CRUD-operasjonene
enum CrudType { create, read, update, delete }

class CrudButton extends StatelessWidget {
  final CrudType type;
  final VoidCallback action;
  final bool isLoading; // Viser en snurrebass hvis Cubit/Bloc laster
  final String? customLabel; // Valgfri tekst hvis du ikke vil bruke standarden

  const CrudButton({
    super.key,
    required this.type,
    required this.action,
    this.isLoading = false,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 1. Definerer farge og tekst basert på CRUD-typen
    final String label = customLabel ?? _getDefaultLabel();
    final ButtonStyle style = _getButtonStyle(theme);

    // Hvis appen laster, deaktiverer vi knappen og viser en snurrebass
    if (isLoading) {
      return FilledButton.tonal(
        style: style,
        onPressed: null,
        child: const SizedBox(
          height: 18,
          width: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    // 2. Sletting krever Long Press for sikkerhet, de andre krever vanlig trykk
    if (type == CrudType.delete) {
      return FilledButton.tonal(
        style: style,
        onPressed: () {
          // Viser en advarsel om å holde inne
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Hold to delete'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        onLongPress: action, // Kjører handlingen ved langt trykk
        child: Text(label),
      );
    }

    // Standard knapp for Create, Read og Update
    return FilledButton(
      style: style,
      onPressed: action, // Kjører handlingen ved vanlig trykk
      child: Text(label),
    );
  }

  // Hjelpemetode for standardtekst
  String _getDefaultLabel() {
    switch (type) {
      case CrudType.create: return 'New';
      case CrudType.read:   return 'Show';
      case CrudType.update: return 'Update';
      case CrudType.delete: return 'Delete';
    }
  }

  // Hjelpemetode for fargestiler basert på appens fargetema
  ButtonStyle _getButtonStyle(ThemeData theme) {
    final baseStyle = FilledButton.styleFrom(
      minimumSize: const Size(80, 38),
      padding: const EdgeInsets.symmetric(horizontal: 16),
    );

    switch (type) {
      case CrudType.delete:
        return baseStyle.copyWith(
          backgroundColor: WidgetStatePropertyAll(theme.colorScheme.errorContainer),
          foregroundColor: WidgetStatePropertyAll(theme.colorScheme.onErrorContainer),
        );
      case CrudType.update:
        return baseStyle.copyWith(
          backgroundColor: WidgetStatePropertyAll(theme.colorScheme.primaryFixed),
          foregroundColor: WidgetStatePropertyAll(theme.colorScheme.onPrimaryFixed),
        );
      default:
        return baseStyle; // Bruker standard primærfarge for Create og Read
    }
  }
}
