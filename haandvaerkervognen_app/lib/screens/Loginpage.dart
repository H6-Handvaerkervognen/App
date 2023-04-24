import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:haandvaerkervognen_app/services/HttpService.dart';
import 'package:haandvaerkervognen_app/screens/Frontpage.dart';
import 'package:haandvaerkervognen_app/screens/RegisterPage.dart';
import 'package:haandvaerkervognen_app/screens/AlarmSettingsPage.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final http = HttpService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Form(
        key: _formKey,
        child: SizedBox(
          height: 350,
          width: 350,
          child: Column(
            children: [
              //Padding for username input field
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: 'Indtast brugernavn',
                    labelText: 'brugernavn',
                    prefixIcon: const Icon(Icons.person),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => usernameController.clear(),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Angiv venligst et brugernavn';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.done,
                ),
              ),
              //Padding for password input field
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Indtast kodeord',
                    labelText: 'kodeord',
                    prefixIcon: const Icon(Icons.lock_open),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => passwordController.clear(),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Angiv venligst et kodeord';
                    }
                    return null;
                  },
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                ),
              ),
              //Login button
              ElevatedButton(
                onPressed: () async {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    //try to login
                    //await http.login(usernameController.text, passwordController.text);
                    goToFrontPage();
                  }
                },
                child: const Text('Login'),
              ),
              //Go to register page
              ElevatedButton(
                onPressed: () async {
                  goToRegister();
                },
                child: const Text('Registrer'),
              ),
            ],
          ),
        ),
      )),
    );
  }

  void goToFrontPage() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => Frontpage(http: http)));
  }

  void goToRegister() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const RegisterPage()));
  }
}
