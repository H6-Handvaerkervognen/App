import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

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

  void registerUser() {
    if (_formKey.currentState!.validate()) {
      //Send register request
      if (true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${usernameController.text} er blevet registeret!'),
          ),
        );
        Navigator.pop(context);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Noget er gået galt: Fejl: '),
        ),
      );
    }
  }
}
