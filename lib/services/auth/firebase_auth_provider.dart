import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseAuthException, GoogleAuthProvider, UserCredential;
import '../../firebase_options.dart';


class FirebaseAuthProvider implements AuthProvider{
  @override
  Future<AuthUser> createUser({required String email, required String password,}) async {
    try{
     await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
     final user = currentUser;
     if(user!=null){
       return user;
     }else{
        throw UserNotLoggedInAuthException();
     }
    }on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }

  @override
  AuthUser? get currentUser {
    final user=FirebaseAuth.instance.currentUser;
    if(user!=null){
      return AuthUser.fromFirebase(user);
    }else{
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) async {
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if(user!=null){
        return user;
      }else{
        throw UserNotLoggedInAuthException();
      }
    }on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundAuthException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordAuthException();
      } else if(e.code == 'invalid-email'){
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (e) {
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async {
    final user=FirebaseAuth.instance.currentUser;
    if(user!=null){
      await FirebaseAuth.instance.signOut();
    }else{
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() async{
    final user=FirebaseAuth.instance.currentUser;
    if(user!=null){
      await user.sendEmailVerification();
    }else{
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<AuthUser> logInWithGoogle() async {
      try {
        await signInWithGoogle();
        final user = currentUser;
        if(user!=null){
          return user;
        }else{
          throw UserNotLoggedInAuthException();
        }
      } catch (e) {
        throw GenericAuthException();
      }
    }
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the Google authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Sign in to Firebase with the Google [UserCredential]
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}