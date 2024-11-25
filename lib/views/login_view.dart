import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';

import '../widgets/toast.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
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
        title: const Text('Login'),
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
                    decoration:
                    const InputDecoration(hintText: 'Enter Password'),
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                  ),
                  TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;
                      try {
                        context.read()<AuthBloc>().add(AuthEventLogIn(email, password));
                      } on UserNotFoundAuthException catch (_) {
                        showErrorToast('No such user exists.');
                      } on WrongPasswordAuthException catch(_){
                        showErrorToast('Incorrect password');
                      } on InvalidEmailAuthException catch(_){
                        showErrorToast('Invalid email');
                      } catch(_){
                        showErrorToast('An unknown error occurred. Please try again.');
                      }
                    },
                    child: const Text(
                      'Login',
                      selectionColor: Colors.blue,
                    ),
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
                          registerRoute,
                              (route) => false,
                        );
                      },
                      child: const Text('Not registered yet? Register here!'))
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

// Future<void> showErrorDialog(BuildContext context, String text) {
//   return showDialog(context: context, builder: (context) {
//     AlertDialog(
//       title: const Text('An error occured'),
//     );
//   },)
// }
