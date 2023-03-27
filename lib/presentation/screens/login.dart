import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import '../../infrastructure/google_auth/google_auth_repo.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final authorizationRepository = GoogleAuthenticationRepository();

  @override
  Widget build(BuildContext context) {
    print('TESTTESTTEST');
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                      'Welcome to YoziCare!'
                  ),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.lightGreen
                      ),
                      onPressed: _signInWithGoogle,
                      icon: const Icon(Icons.login),
                      label: const Text('Sign in')
                  )
                ]
            )
        )
    );
  }

  void _signInWithGoogle() async {
    var signInState = await authorizationRepository.signIn();
    if (signInState.isSuccessful) {
      ScaffoldMessenger
          .of(context)
          .showSnackBar(const SnackBar(content: Text('Signed in!'))
      );
      if (signInState.isNewUser) {
        context.router.replaceNamed('/intro');
      } else {
        context.router.replaceNamed('/');
      }
    }
  }
}