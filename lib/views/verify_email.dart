import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: Column(
        children: [
          const Text('Please verify your email address'),
          TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                try {
                  await FirebaseAuth.instance.signOut();
                }  catch (e) {
                  devtools.log(e.toString());
                }
                Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false,);
              }, child: const Text('Send email verification')),
        ],
      ),
    );
  }
}