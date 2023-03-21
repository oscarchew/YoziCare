import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../infrastructure/google_auth/google_auth_repo.dart';

class SettingsScreen extends StatefulWidget {

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  final authorizationRepository = GoogleAuthenticationRepository();

  @override
  Widget build(BuildContext context) => Center(
      child: ElevatedButton(
        onPressed: _signOut, child: const Text('Sign out'),
      ),
    );

  void _signOut() async => await createDialog(
      title: 'Signing Out',
      content: 'Do you really want to sign out?',
      actions: [
        ElevatedButton(
            child: const Text('Yes'),
            onPressed: () {
              authorizationRepository.signOut();
              context.router.replaceNamed('/login');
            }
        ),
        ElevatedButton(
            child: const Text('No'),
            onPressed: () => Navigator.pop(context)
        ),
      ]
  );

  Future<void> createDialog({
    required String title,
    required String content,
    required List<Widget> actions
  }) async => showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: actions
      )
  );
}