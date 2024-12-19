import 'package:composition/data/models/authenticated_user.dart';
import 'package:composition/data/services/user_service.dart';
import 'package:composition/pages/create_page.dart';
import 'package:composition/pages/home.dart';
import 'package:composition/pages/list_page.dart';
import 'package:composition/pages/signup_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  UserService userService = UserService();

  loginUser() async {
    // déclencher le loading
    setState(() {
      isLoading = true;
    });

    try {
      // Prépare les données à envoyer
      Map<String, dynamic> data = {
        'email': emailController.text,
        'strategy': 'local',
        'password': passwordController.text
      };

      // Lancer la requête
      UserService userService = UserService();
      AuthenticatedUser authUser = await userService.login(data);

      // Initialiser une instance de shared preference
      final sharedPref = await SharedPreferences.getInstance();

      // Sauvegerder le token en mémoire
      await sharedPref.setString("token", authUser.accessToken!);

      // Afficher un message de succès
      Fluttertoast.showToast(msg: "Utilisateur connecté avec succès");

      // rediriger vers la page home
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    } on DioException catch (e) {
      // Quand erreur de requête, afficher les erreurs et le status code
      if (e.response != null) {
        print(e.response?.data);
        print(e.response?.statusCode);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.requestOptions);
        print(e.message);
      }

      Fluttertoast.showToast(msg: "Une erreur est survenue");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Se connecter",
            style: TextStyle(
                color: Colors.blue, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        icon: Icon(Icons.alternate_email),
                        label: Text("Email *")),
                    validator: (String? value) {
                      return value == null || value == ""
                          ? "Ce champ est obligatoire"
                          : null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                        icon: Icon(Icons.lock), label: Text("Password *")),
                    validator: (String? value) {
                      return value == null || value == ""
                          ? "Ce champ est obligatoire"
                          : null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await loginUser();
                        }
                      },
                      child: isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              "Valider",
                              style: TextStyle(fontSize: 20),
                            ))
                ],
              )),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignupPage()));
                },
                child: Text(
                  "Créer un nouveau compte",
                  style: TextStyle(fontSize: 18),
                )),
          )
        ],
      ),
    );
  }
}
