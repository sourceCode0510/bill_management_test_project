import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'models/data_offline.dart';
import './colors.dart';

import './screens/home_screen.dart';
import './screens/member_screen.dart';
import './screens/payment_screen.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => Data(),
    child: const MyApp(),
  ));
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Color(0xffffffff),
      statusBarIconBrightness: Brightness.dark,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: blue,
      ),
      initialRoute: HomeScreen.name,
      routes: {
        HomeScreen.name: (_) => const HomeScreen(),
        MemberScreen.name: (_) => const MemberScreen(),
        PaymentScreen.name: (_) => const PaymentScreen(),
      },
    );
  }
}
