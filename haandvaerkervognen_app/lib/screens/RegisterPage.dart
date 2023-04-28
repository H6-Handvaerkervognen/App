import 'package:flutter/material.dart';
import 'package:haandvaerkervognen_app/services/HttpService.dart';

///Page for creating a new user
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.http});

  final HttpService http;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrer'),
      ),
      body: Center(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                //Username field
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: 'Vælg et brugernavn',
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
                const SizedBox(
                  height: 15,
                ),
                //Password field
                TextFormField(
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
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(
                  height: 15,
                ),
                //Re-enter password field
                TextFormField(
                  controller: confirmPassController,
                  decoration: InputDecoration(
                    hintText: 'bekræft kodeord',
                    labelText: 'bekræft kodeord',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => passwordController.clear(),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Angiv venligst kodeordet igen';
                    }
                    if (value != passwordController.text) {
                      return 'kodeordet stemmer ikke overens';
                    }
                    return null;
                  },
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    onPressed: registerUser, child: const Text('Registrer'))
              ],
            )),
      ),
    );
  }

  ///Method for creating a new user that you can log in with
  Future<void> registerUser() async {
    if (_formKey.currentState!.validate()) {
      //Send register request
      bool res = await widget.http
          .registerUser(usernameController.text, passwordController.text);

      //Show snackbar in another method
      if (res) {
        showSnackBar('${usernameController.text} er blevet registeret!');
        //This should fix the "Don't use BuildContext across async gaps" according to this:
        //https://dart-lang.github.io/linter/lints/use_build_context_synchronously.html
        if (!context.mounted) return;
        Navigator.pop(context);
      } else {
        showSnackBar(
            'Noget er desværrre gået galt, brugeren kunne ikke registreres.');
      }
    }
  }

  ///Shows a snackbar with a given text
  showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}
