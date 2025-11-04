import 'package:flutter/material.dart';
import 'package:eni_l10n/eni_l10n.dart';
import 'package:eni_svc/eni_svc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ServiceScope(
    child: MyApp(),
  )
    ..addL10n()
    ..addPackage(
      makePackage("app")
        ..useL10n(
          useJson: false,
          useYaml: true,
        ),
    ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void _switchLocale() {
    setState(() {
      _locale = _locale.languageCode == 'en'
          ? const Locale('de')
          : const Locale('en');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: ValueKey(_locale.toString()),
      locale: _locale,
      localizationsDelegates: context.localizationService.delegates,
      supportedLocales: const [Locale('en'), Locale('de')],
      home: HomePage(onSwitch: _switchLocale),
    );
  }
}

class HomePage extends StatelessWidget {
  final VoidCallback onSwitch;

  const HomePage({super.key, required this.onSwitch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("app.title".tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "greeting".tr(namedArgs: {"name": "Maria"}),
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onSwitch,
              child: Text("switch.language".tr()),
            ),
          ],
        ),
      ),
    );
  }
}
