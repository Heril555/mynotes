import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/main.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/widgets/toast.dart';

import '../services/auth/bloc/auth_bloc.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  void dispose() async {
    await AuthService.firebase().logOut();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          const Text('An email has been sent for verification. Please open it to verify'),
          const Text("If you didn't got the email press the button below."),
          TextButton(
              onPressed: () async {
                try {
                  context.read<AuthBloc>().add(const AuthEventSendEmailVerification());
                }  catch (e) {
                  devtools.log(e.toString());
                  showErrorToast(e.toString());
                }
              },
              child: const Text('Send email verification')),
          TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEventLogOut());
              },
              child: const Text('Register Page'))
        ],
      ),
    );
  }
}