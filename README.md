# flutter_supabase_pack

## Prosjektbeskrivelse

`flutter_supabase_pack` er en Flutter-app for å planlegge og holde oversikt over
pakkelister (f.eks. til fjellturer/friluftsliv). Brukeren kan opprette pakkeplaner
(`packList`), knytte utstyr (`gear`) til hver plan via en kobling
(`pakningsplan_utstyr`), og se total vekt for utstyret i hver plan. All data
lagres i [Supabase](https://supabase.com/) (Postgres + PostgREST).

## Sentrale avhengigheter

| Pakke | Formål |
|---|---|
| [`supabase_flutter`](https://pub.dev/packages/supabase_flutter) | Klient for autentisering og CRUD mot Supabase/Postgres-backend |
| [`go_router`](https://pub.dev/packages/go_router) | Deklarativ routing/navigasjon, inkl. bunnmeny med `StatefulShellRoute` |
| [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) | State management (Cubit) - kobler UI til forretningslogikk/repositories |
| [`equatable`](https://pub.dev/packages/equatable) | Verdi-basert `==`/`hashCode` for Cubit-states, uten manuell boilerplate |
| [`get_it`](https://pub.dev/packages/get_it) | Service locator for dependency injection (repositories/services) |
| [`cupertino_icons`](https://pub.dev/packages/cupertino_icons) | iOS-stil ikoner |
| [`flutter_lints`](https://pub.dev/packages/flutter_lints) (dev) | Anbefalte lint-regler for konsistent kodekvalitet |
| [`flutter_test`](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html) (dev) | Rammeverk for widget-/enhetstester |

## Guide: hvordan de sentrale pakkene brukes i dette prosjektet

### `go_router` — navigasjon og bunnmeny

All routing er samlet i `lib/routing/app_router.dart`. Appens faner er definert
i `AppNavDestination.mainBottomNavDestinations`
(`lib/presentation/core/navigation/nav_bar_destinations.dart`) - hvert element
har en `path`, `label`, `icon` og en `screenBuilder`. `app_router.dart`
genererer automatisk én `StatefulShellBranch` (= én fane) per element i denne
listen, og `BottomNav`-widgeten (`presentation/core/widgets/bottom_nav.dart`)
tegner selve `NavigationBar` fra samme liste.

**For å legge til en ny fane i bunnmenyen:** legg kun til et nytt
`AppNavDestination`-objekt i `mainBottomNavDestinations` - bunnmeny og routing
oppdateres automatisk, uten å røre `app_router.dart` eller `bottom_nav.dart`.

**For å navigere programmatisk** (f.eks. fra en knapp): bruk
`context.go('/gear')` eller `context.push('/gear/detaljer')` for nøstede ruter.

### `flutter_bloc` + `equatable` — state management (Cubit)

Hver feature har en `viewmodel/`-mappe med to filer:
- `<feature>_state.dart` - en `sealed class` med alle mulige tilstander
  (`Initial`, `Loading`, `Loaded`, `Error`), som extender `Equatable`.
- `<feature>_cubit.dart` - selve `Cubit<...State>`, som avhenger av et
  repository-**interface** (aldri en konkret Supabase-implementasjon direkte)
  og kaller `emit(...)` for å oppdatere tilstanden.

Koblingen til UI skjer i selve skjerm-widgeten (f.eks. `gear_screen.dart`) med
`BlocProvider` (oppretter Cubit-en) og `BlocBuilder`/`switch` (rebuilder UI når
state endres). Se `presentation/features/gear_view/` for et komplett eksempel
å kopiere mønsteret fra ved nye features.

### `get_it` — dependency injection

All registrering av avhengigheter (services, repositories) skjer i
`lib/core/service_locator.dart`, i funksjonen `setupServiceLocator()`, som
kalles én gang i `main()` før `runApp()`.

```dart
sl.registerLazySingleton<SupabaseService>(() => SupabaseService());
sl.registerLazySingleton<GearRepository>(
  () => SupabaseGearRepositoryImpl(sl<SupabaseService>()),
);
```

**For å legge til en ny feature sitt repository:** registrer interfacet
(f.eks. `PackPlanRepository`) og dens konkrete implementasjon på samme måte,
og hent den i skjermens `BlocProvider` med `sl<PackPlanRepository>()` - se
`gear_screen.dart` for eksempel. Cubits registreres **ikke** i `sl` - de
opprettes per skjerm-instans via `BlocProvider`, siden hver skjerm skal ha sin
egen, uavhengige tilstand.

## Arkitekturvalg

Prosjektet følger et lagdelt arkitekturmønster inspirert av
[Flutter sin offisielle arkitekturanbefaling](https://docs.flutter.dev/app-architecture)
og MVVM-prinsipper:

- **Separasjon av UI, forretningslogikk og data.** UI (widgets) skal aldri
  snakke direkte med Supabase — all databasekommunikasjon går via et eget
  data-lag, slik at logikken kan testes og gjenbrukes uavhengig av UI.
- **Repository-pattern med interfaces.** Repositories eksponeres som abstrakte
  klasser (interfaces), slik at datakilden (Supabase i dag) kan byttes ut
  eller mockes i tester uten at resten av appen (view models/UI) må endres.
  Dette følger *Dependency Inversion*-prinsippet fra SOLID.
- **Eget domenelag.** `domain/models` inneholder rene forretningsmodeller,
  uavhengig av hvordan data hentes eller lagres. Dette gjør at endringer i
  databasestrukturen (f.eks. Supabase-kolonner) kun påvirker mapping-koden i
  data-laget, ikke UI eller forretningslogikk.
- **Feature-basert UI-struktur.** UI er organisert per feature
  (`gear_view`, `packplans_view`) i stedet for per widget-type, slik at alt
  som hører til én skjerm/flyt er samlet på ett sted og enkelt å finne.

## Mappestruktur og ansvar

```
lib/
  data/
    model/          -> DTO-er (Data Transfer Objects)
    services/        -> Rå kommunikasjon med Supabase
    repositories/     -> Forretningslogikk for CRUD + mapping til domain-modeller
  domain/
    models/           -> Rene domenemodeller
  presentation/
    core/             -> Delte/gjenbrukbare widgets og temaer på tvers av features
    features/         -> Én mappe per feature (skjerm/flyt)
      gear_view/
      packplans_view/
```

### `data/model/`
Inneholder DTO-klasser som speiler den rå JSON-strukturen Supabase returnerer
(f.eks. samme feltnavn og typer som i databasen). Har `fromJson()`/`toJson()`
for (de)serialisering. **Hvorfor:** holder database-/API-spesifikke detaljer
isolert, slik at resten av appen ikke trenger å bry seg om hvordan data ser ut
"på ledningen".

### `data/services/`
Inneholder klasser som gjør de faktiske Supabase-kallene (select/insert/update/
delete) og returnerer DTO-er. Ingen forretningslogikk her — kun teknisk
kommunikasjon med backend. **Hvorfor:** skiller *hvordan* data hentes fra
*hva* appen trenger den til, og gjør det enkelt å bytte backend (f.eks. til
REST/Firebase) ved kun å skrive en ny service med samme metodesignaturer.

### `data/repositories/`
Definerer repository-interfacer (abstrakte klasser) og konkrete
implementasjoner som bruker en eller flere services til å hente data, mapper
DTO-er til domenemodeller, og kan legge til logikk som caching, feilhåndtering
eller kombinering av flere datakilder. **Hvorfor:** view models/Cubits
avhenger kun av interfacet, ikke den konkrete Supabase-implementasjonen — dette
gjør koden testbar (mock av repository) og gjør det trivielt å bytte datakilde
senere uten å endre UI eller logikk.

### `domain/models/`
Rene, plattform- og databaseuavhengige forretningsmodeller (f.eks. `Gear`,
`PackPlan`). Kan inneholde beregnede egenskaper og forretningsregler (f.eks.
total vekt for en pakkeplan). **Hvorfor:** gir et stabilt lag som resten av
appen (view models og UI) kan stole på, uavhengig av endringer i
databasestruktur eller ekstern API-respons.

### `presentation/core/`
Delte, gjenbrukbare UI-komponenter og temaer som brukes på tvers av flere
features (f.eks. felles knapper, farger, tekststiler). **Hvorfor:** unngår
duplisering av UI-kode og sikrer konsistent utseende i hele appen.

### `presentation/features/<feature_name>/`
Én mappe per feature/skjerm (f.eks. `packplans_view`, `gear_view`), som samler
alt UI-relatert for den funksjonaliteten — skjermer, widgets og (etter hvert)
tilhørende view models/Cubits. **Hvorfor:** gjør det enkelt å finne, endre og
eventuelt fjerne en hel feature uten å lete gjennom flere spredte mapper.

## Kom i gang

Se [Flutter sin offisielle dokumentasjon](https://docs.flutter.dev/) for
generell oppsett av utviklingsmiljø:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)
