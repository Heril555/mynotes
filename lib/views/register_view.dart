import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';
import 'package:mynotes/widgets/toast.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController();
    _password = TextEditingController();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(
                children: [
                  TextField(
                    controller: _email,
                    decoration: const InputDecoration(hintText: 'Enter Email'),
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                  ),
                  TextField(
                    controller: _password,
                    decoration: const InputDecoration(hintText: 'Enter Password'),
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                  ),
                  TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      try {
                        await AuthService.firebase().createUser(email: email, password: password);
                        await AuthService.firebase().sendEmailVerification();
                        Navigator.of(context).pushNamed(verifyRoute);
                      } on EmailAlreadyInUseAuthException catch (_) {
                        showErrorToast('Email already in use.');
                      } on InvalidEmailAuthException catch(_){
                        showErrorToast('Invalid email.');
                      } on WeakPasswordAuthException catch(_){
                        showErrorToast('Weak password.');
                      }
                      catch(_){
                        showErrorToast('An unknown error occurred. Please try again.');
                      }
                    },
                    child: const Text('Register',selectionColor: Colors.blue,),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await AuthService.firebase().logInWithGoogle();
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          notesRoute,
                              (route) => false,
                        );
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: const Text('Sign in with Google'),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute,
                              (route) => false,
                        );
                      },
                      child: const Text('Already registered? Login here!'))
                ],
              );
            default:
              return const Text('Loading...');
          }
        },
      ),
    );
  }
}