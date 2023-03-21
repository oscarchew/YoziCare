class SignInState {

  final bool isSuccessful;
  final bool isNewUser;
  final String username;

  const SignInState(this.isSuccessful, this.isNewUser, this.username);
}

abstract class AuthenticationRepositoryImpl {

  Future<SignInState> signIn();
  Future<void> signOut();
}