import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'presentation/todos.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://jkcatsdfchzwccdfvceo.supabase.co',
    anonKey: 'sb_publishable_41KF9XpkGG7656n72Q83pA_epzynYvP',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Todos(),
    );
  }
}

