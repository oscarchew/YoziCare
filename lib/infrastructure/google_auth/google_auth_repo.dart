import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/authentication/auth.dart';

class GoogleAuthenticationRepository implements AuthenticationRepositoryImpl {

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  GoogleAuthenticationRepository()
      : _firebaseAuth = FirebaseAuth.instance,
        _googleSignIn = GoogleSignIn();

  @override
  Future<SignInState> signIn() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return const SignInState(false, false, 'error');

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final authResult = await _firebaseAuth.signInWithCredential(credential);
    final isNewUser = authResult.additionalUserInfo!.isNewUser;

    return SignInState(true, isNewUser, googleUser.displayName!);
  }

  @override
  Future<void> signOut() async {
    Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }
}