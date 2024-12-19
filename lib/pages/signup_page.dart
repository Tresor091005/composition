import 'package:composition/data/services/user_service.dart';
import 'package:composition/pages/login_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  bool isLoading = false;

  UserService userService = UserService();

  createUser() async {
    setState(() {
      isLoading = true;
    });

    try {
      Map<String, dynamic> data = {
        'email': emailController.text,
        'fullname': nameController.text,
        'password': passwordController.text
      };

      UserService userService = UserService();
      await userService.create(data);

      passwordController.text = "";
      nameController.text = "";
      emailController.text = "";

      Fluttertoast.showToast(msg: "Utilisateur créé avec succès");
    } on DioException catch (e) {
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
            "Créer un compte",
            style: TextStyle(
                color: Colors.blue, fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        icon: Icon(Icons.person),
                        label: Text("Nom & Prénom *")),
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
                          await createUser();
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
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text(
                  "Se connecter",
                  style: TextStyle(fontSize: 18),
                )),
          )
        ],
      ),
    );
  }
}
