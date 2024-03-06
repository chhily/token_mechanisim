import 'package:flutter/material.dart';

import '../dio/base_dio.dart';

class LoginViewPage extends StatefulWidget {
  const LoginViewPage({super.key});

  @override
  State<LoginViewPage> createState() => _LoginViewPageState();
}

class _LoginViewPageState extends State<LoginViewPage> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  // Credentials? _credentials;
  // late Auth0 auth0;

  @override
  void initState() {
    super.initState();
    onInit();
  }

  void onInit() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  }

  void onLogin() {
    BaseApiService().onRequest(
      path: "/login",
      method: 'post',
      data: {
        "username": usernameController.text,
        "password": passwordController.text,
      },
      onSuccess: (response) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: usernameController,
            decoration: InputDecoration(hintText: "Username"),
          ),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(hintText: "Password"),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
              onPressed: () {
                onLogin();
              },
              child: Text("Login"))
        ],
      ),
    );
  }
}
