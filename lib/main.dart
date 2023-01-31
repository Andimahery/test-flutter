import 'package:flutter/material.dart';
import 'package:test_flutter/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  final ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
    foregroundColor: Colors.black,
    side: const BorderSide(
        color: Colors.black26, width: 0.5, style: BorderStyle.solid),
  );

  final ButtonStyle outlinedButtonStyle2 = ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
        side: const BorderSide(
            color: Colors.black26, width: 0.5, style: BorderStyle.solid),
      ),
    ),
  );
  final ButtonStyle elevatedButtonStyle = ButtonStyle(
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: createMaterialColor(Colors.black),
        outlinedButtonTheme:
            OutlinedButtonThemeData(style: outlinedButtonStyle2),
        elevatedButtonTheme:
            ElevatedButtonThemeData(style: elevatedButtonStyle),
      ),
      home: const HomeView(),
    );
  }
}
