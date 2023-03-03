import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../infrastructure/google_auth/google_auth_repo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _authRepo = GoogleAuthenticationRepository();

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                    'Welcome to CKD Care!'
                ),
                ElevatedButton(
                    onPressed: _signInWithGoogle,
                    child: const Text('Sign in with Google')
                )
              ]
          )
      )
  );

  void _signInWithGoogle() async {
    var signInState = await _authRepo.signIn();
    if (signInState.isSuccessful) {
      ScaffoldMessenger
          .of(context)
          .showSnackBar(const SnackBar(content: Text('Signed in!'))
      );
      if (signInState.isNewUser) {
        context.router.replaceNamed('/intro');
      } else {
        context.router.replaceNamed('/home');
      }
      // context.router.replaceNamed('/family-history');
    }
  }
}