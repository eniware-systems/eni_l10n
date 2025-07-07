import 'package:eni_l10n/eni_l10n.dart';
import 'package:eni_svc/eni_svc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MyLocales extends LocalizationProvider {
  @override
  bool isSupported(Locale locale) {
    return true;
  }

  @override
  Future<Map<String, dynamic>> load(Locale locale) async {
    return {
      "foo": "bar",
      "baz": "{wow}",
      "unnamed2": "%%{}%%{}%%",
      "unnamed2_indices": "%%{1}%%{0}%%",
    };
  }
}

void main() {
  testWidgets('simple localizations can be used in Text', (tester) async {
    await tester.pumpWidget(ServiceScope(
        child: Builder(
      builder: (context) => MaterialApp(
          localizationsDelegates: context.localizationService.delegates,
          home: Builder(
              builder: (context) => Scaffold(body: const Text("foo").tr()))),
    ))
      ..register(LocalizationService.descriptor)
      ..provide<LocalizationProvider>(MyLocales()));

    await tester.pumpAndSettle();

    expect(find.text("bar"), findsOneWidget);
  });

  testWidgets('localizations with formats can be used in Text', (tester) async {
    await tester.pumpWidget(ServiceScope(
        child: Builder(
      builder: (context) => MaterialApp(
          localizationsDelegates: context.localizationService.delegates,
          home: Builder(
              builder: (context) => Scaffold(
                  body: const Text("baz")
                      .tr(namedArgs: {"wow": "formatted!!°"})))),
    ))
      ..register(LocalizationService.descriptor)
      ..provide<LocalizationProvider>(MyLocales()));

    await tester.pumpAndSettle();

    expect(find.text("formatted!!°"), findsOneWidget);
  });

  testWidgets('localizations work for unnamed arguments', (tester) async {
    await tester.pumpWidget(ServiceScope(
        child: Builder(
      builder: (context) => MaterialApp(
          localizationsDelegates: context.localizationService.delegates,
          home: Builder(
              builder: (context) =>
                  Scaffold(body: const Text("unnamed2").tr(args: ["a", "b"])))),
    ))
      ..register(LocalizationService.descriptor)
      ..provide<LocalizationProvider>(MyLocales()));

    await tester.pumpAndSettle();

    expect(find.text("%%a%%b%%"), findsOneWidget);
  });

  testWidgets('localizations work for unnamed arguments with indices',
      (tester) async {
    await tester.pumpWidget(ServiceScope(
        child: Builder(
      builder: (context) => MaterialApp(
          localizationsDelegates: context.localizationService.delegates,
          home: Builder(
              builder: (context) => Scaffold(
                  body: const Text("unnamed2_indices").tr(args: ["a", "b"])))),
    ))
      ..register(LocalizationService.descriptor)
      ..provide<LocalizationProvider>(MyLocales()));

    await tester.pumpAndSettle();

    expect(find.text("%%b%%a%%"), findsOneWidget);
  });
}
