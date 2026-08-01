import 'package:flutter_supabase_pack/data/repositories/gear_repo/gear_repository_interface.dart';
import 'package:flutter_supabase_pack/data/repositories/gear_repo/supabase_gear_repository_impl.dart';
import 'package:flutter_supabase_pack/data/services/supabase_service/supabase_service.dart';
import 'package:get_it/get_it.dart';

/// Global service locator-instans. Brukes til å hente avhengigheter
/// hvor som helst i appen (også utenfor widget-treet), i stedet for
/// at klasser oppretter sine egne avhengigheter internt.
final GetIt sl = GetIt.instance;

/// Registrerer alle avhengigheter i appen. Kalles ÉN gang i main(),
/// før runApp(). Rekkefølgen betyr noe: registrer det som IKKE har
/// avhengigheter selv (SupabaseService) FØR det som avhenger av det
/// (GearRepository).
Future<void> setupServiceLocator() async {
  // Bunnen av kjeden - ingen egne avhengigheter.
  sl.registerLazySingleton<SupabaseService>(() => SupabaseService());

  // Avhenger av SupabaseService, hentes FRA sl (ikke opprettet selv).
  sl.registerLazySingleton<GearRepository>(
    () => SupabaseGearRepositoryImpl(sl<SupabaseService>()),
  );

  // Cubits registreres IKKE her - de opprettes per skjerm-instans via
  // BlocProvider (se gear_screen.dart), siden hver skjerm skal ha sin
  // egen, uavhengige Cubit-tilstand, ikke en delt singleton.
}
