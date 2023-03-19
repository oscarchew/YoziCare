import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/screen/google_maps_all.dart';

import '../../../infrastructure/google_auth/google_auth_repo.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final _authRepo = GoogleAuthenticationRepository();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Home page'),
    ),
    body: const Center(
      child: Text(
        'Signed in successfully!'
      )
    ),
    drawer: Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.lightBlue,
            ),
            child: Text('Hi, ${FirebaseAuth.instance.currentUser!.displayName}!'),
          ),
          ListTile(
            title: const Text('My CKD data'),
            onTap: () => context.router.pushNamed(''),
          ),
          ListTile(
            title: const Text('Hydration analysis'),
            onTap: () {

            },
          ),
          ListTile(
            title: const Text('Map'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                return const GoogleMaps(); // import google_map_all.dart directly
              }));
            },
          ),
          ListTile(
            title: const Text('Sign out'),
            onTap: _signOut
          )
        ],
      )
    ),
  );

  void _signOut() async => await _signOutDialog(context);

  Future<void> _signOutDialog(BuildContext context) async => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Signing Out'),
      content: const Text('Do you really want to sign out?'),
      actions: [
        ElevatedButton(
            child: const Text("Yes"),
            onPressed: () {
              _authRepo.signOut();
              context.router.replaceNamed('/');
            }
        ),
        ElevatedButton(
            child: const Text("No"),
            onPressed: () => Navigator.pop(context)
        ),
      ],
    ));
}