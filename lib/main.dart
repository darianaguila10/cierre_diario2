import 'package:cierre_diario2/features/daily_closing/services/daily_closing_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/daily_closing/ui/pages/daily_closing.page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DailyClosingService()),
      ],
      child: MaterialApp(
        title: 'Cierre diario',
        theme: ThemeData(dialogBackgroundColor: Color(0xFF2c2c2c),dialogTheme: DialogTheme(
          shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)))
        ),
            //color del style in formfield
            textTheme:
                Theme.of(context).textTheme.apply(bodyColor: Colors.white),
            appBarTheme: AppBarTheme(color: Color(0xFF2c2c2c)),
            textSelectionTheme: const TextSelectionThemeData(
              cursorColor: Color(0xFFB1BDBA),
              selectionColor: Color.fromARGB(255, 33, 123, 241),
              selectionHandleColor: Color(0xFFB1BDBA),
            ),
            inputDecorationTheme: InputDecorationTheme(
                counterStyle: TextStyle(color: const Color(0xFFB1BDBA)),
                iconColor: const Color(0xFFB1BDBA),
                focusColor: Colors.white,
                floatingLabelStyle: TextStyle(color: const Color(0xFFB1BDBA)),
                labelStyle: TextStyle(color: Colors.white)),
            scaffoldBackgroundColor: const Color(0xFF1e1e1e),
            colorScheme: ColorScheme.fromSwatch().copyWith(
                onSurface: const Color(0xFFB1BDBA),
                primary: const Color(0xFFB1BDBA),
                secondary: const Color(0xFFB1BDBA))),
        home: const DailyClosingPage(),
      ),
    );
  }
}
