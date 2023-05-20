import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import '../../infrastructure/google_auth/google_auth_repo.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final authorizationRepository = GoogleAuthenticationRepository();

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Welcome to YoziCare!',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.lightGreen
                    )
                ),
                const SizedBox(height: 50),
                const Image(
                  image: AssetImage('assets/icon/icon.jpg'),
                  width: 200,
                ),
                const SizedBox(height: 50),
                SignInButton(
                    Buttons.googleDark,
                    onPressed: _signInWithGoogle
                )
              ]
          )
      )
  );

  void _signInWithGoogle() async {
    final signInState = await authorizationRepository.signIn();
    final isNewUser = signInState.isSuccessful && signInState.isNewUser;
    context.router.replaceNamed(isNewUser ? '/intro' : '/');
  }
}