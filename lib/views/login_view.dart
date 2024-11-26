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
import 'package:mynotes/utilities/dialogs/loading_dialog.dart';

import '../services/auth/bloc/auth_state.dart';
import '../widgets/toast.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  CloseDialog? _closeDialogHandle;

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateLoggedOut) {
          // final closeDialog = _closeDialogHandle;
          //
          // if (!state.isLoading && closeDialog != null) {
          //   closeDialog();
          //   _closeDialogHandle = null;
          // } else if (state.isLoading && closeDialog == null) {
          //   _closeDialogHandle = showLoadingDialog(
          //     context: context,
          //     text: 'Loading...',
          //   );
          // }
          if (state.exception is UserNotFoundAuthException) {
            showErrorToast('No such user exists.');
          } else if (state.exception is WrongPasswordAuthException) {
            showErrorToast('Incorrect password');
          } else if (state.exception is InvalidEmailAuthException) {
            showErrorToast('Invalid email');
          } else if (state.exception is GenericAuthException) {
            showErrorToast('An unknown error occurred. Please try again.');
          }
        }
      },
      child: Scaffold(
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
                      decoration:
                          const InputDecoration(hintText: 'Enter Email'),
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
                        context.read<AuthBloc>().add(AuthEventLogIn(
                              email,
                              password,
                            ));
                      },
                      child: const Text(
                        'Login',
                        selectionColor: Colors.blue,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        context.read<AuthBloc>().add(const AuthEventLogInWithGoogle());
                      },
                      child: const Text('Sign in with Google'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                          const AuthEventForgotPassword(),
                        );
                      },
                      child: Text(
                        'Forgot Password? Reset here!',
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(
                                const AuthEventShouldRegister(),
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
