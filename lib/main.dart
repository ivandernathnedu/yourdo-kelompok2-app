import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'data/quest_repository.dart';
import 'screens/login_page.dart';
import 'screens/main_shell.dart';
import 'services/auth_service.dart';
import 'services/quest_randomizer.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const YourDoApp());
}

class YourDoApp extends StatelessWidget {
  const YourDoApp({
    super.key,
    this.repository = const QuestRepository(),
    this.randomizer,
    this.authService,
    this.startAuthenticated = false,
  });

  final QuestRepository repository;
  final QuestRandomizer? randomizer;
  final AuthService? authService;
  final bool startAuthenticated;

  @override
  Widget build(BuildContext context) {
    final randomizer = this.randomizer ?? QuestRandomizer();
    final authService = this.authService ?? AuthService();

    return MaterialApp(
      title: 'YourDo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: startAuthenticated
          ? MainShell(repository: repository, randomizer: randomizer)
          : LoginPage(
              repository: repository,
              randomizer: randomizer,
              authService: authService,
            ),
      builder: (context, child) {
        return ColoredBox(
          color: AppColors.background,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
