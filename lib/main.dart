import 'package:composition/pages/home.dart';
import 'package:composition/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String token = await sharedPreferences.getString("token") ?? "";
  runApp(MyApp(
    authToken: token,
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.authToken});

  final String authToken;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage(),
      //home: authToken == "" ? LoginPage() : Home(),
    );
  }
}
