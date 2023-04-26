import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:haandvaerkervognen_app/services/HttpService.dart';
import 'package:haandvaerkervognen_app/screens/Frontpage.dart';
import 'package:haandvaerkervognen_app/screens/RegisterPage.dart';
import 'package:haandvaerkervognen_app/screens/AlarmSettingsPage.dart';

///Landing page of app.
///You can login with an existing user or create a new one by navigating to the register page
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
          child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SizedBox(
            height: 350,
            width: 350,
            child: Column(
              children: [
                //Padding and username input field
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
                //Padding and password input field
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
                      /* bool result = await http.login(
                          usernameController.text, passwordController.text);

                      if (!result) {
                        showSnackBar();
                      } else {
                      } */
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
        ),
      )),
    );
  }

  ///Navigates to the front page
  void goToFrontPage() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                Frontpage(username: usernameController.text, http: http)));
  }

  ///Navigates to the register page
  void goToRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => RegisterPage(http: http)));
  }

  ///Shows a snackbar if the user couldn't login with what was written
  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('De indtastede oplysninger var ikke gyldige')));
  }
}
