import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_router.dart';
import 'get_it_setup.dart';
import 'theme.dart';
import 'set_theme.dart';

void main() async {
  setup();
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(Duration(seconds: 3));
  runApp(
    ChangeNotifierProvider(
      create: (_) => SetTheme(),
      child: TicTacToeApp(),
    ),
  );
}

class TicTacToeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SetTheme>(builder: (context, setTheme, child) {
      return MaterialApp.router(
        routerConfig: AppRouter.router,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: setTheme.themeMode,
      );
    });
  }
}