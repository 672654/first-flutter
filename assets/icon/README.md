# App-ikon (kildebilde)

Legg det ferdige logo-bildet ditt i denne mappen med filnavnet:

```
icon.png
```

## Krav til bildet

- **Størrelse:** minst 1024x1024 px, kvadratisk (1:1)
- **Format:** PNG
- **Bakgrunn:**
  - Helst **transparent** bakgrunn i selve `icon.png` (brukes til iOS og standard Android-ikon).
  - Unngå fin, liten tekst eller detaljer — de blir uleselige når ikonet vises helt ned til 48x48 px på Android.
- **Innhold:** enkel, gjenkjennelig logo midt i bildet, med litt luft/margin rundt (spesielt viktig for "maskable"-varianten på Android/PWA, som kan bli beskåret til en sirkel).

## Etter at du har lagt inn bildet

Kjør følgende i terminalen fra prosjektroten for å generere alle ikon-størrelser for Android, iOS og web/PWA automatisk:

```powershell
flutter pub get
dart run flutter_launcher_icons
```

Dette oppdaterer automatisk:
- `web/favicon.png`, `web/icons/Icon-192.png`, `Icon-512.png` + maskable-variantene
- Alle `android/app/src/main/res/mipmap-*/`-ikonene
- iOS sitt `AppIcon.appiconset`

Du trenger ikke redigere noen av disse filene manuelt — bare bytt ut `icon.png` her og kjør kommandoen på nytt når du vil endre logo igjen.
