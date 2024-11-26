import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';

import '../auth_service.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  AuthBloc(AuthService provider):super(const AuthStateUninitialized(isLoading: true)){
    on<AuthEventInitialize>((event,emit) async {
      emit(const AuthStateLoggedOut(exception: null,isLoading: true,loadingText: 'Initializing...'));
      await provider.initialize();
      final user = provider.currentUser;
      if(user==null){
        emit(const AuthStateLoggedOut(exception: null,isLoading: false,));
      }else if(!user.isEmailVerified){
        emit(const AuthStateNeedsVerification(isLoading: false));
      } else{
        emit(AuthStateLoggedIn(user: user, isLoading: false,));
      }
    });
    // LogIn
    on<AuthEventLogIn>((event, emit)async{
      emit(AuthStateLoggedOut(exception: null, isLoading: true, loadingText: 'Logging In...',));
      final email = event.email;
      final password = event.password;
      try{
        final user=await provider.logIn(email: email, password: password);
        emit(AuthStateLoggedOut(exception: null, isLoading: false));
        if(!user.isEmailVerified){
          emit(const AuthStateNeedsVerification(isLoading: false));
        }else{
          emit(AuthStateLoggedIn(user: user, isLoading: false,));
        }
      }on Exception catch(e){
        emit(AuthStateLoggedOut(exception: e,isLoading: false));
      }
    });
    // LogIn with Google
    on<AuthEventLogInWithGoogle>((event, emit)async{
      emit(AuthStateLoggedOut(exception: null, isLoading: true, loadingText: 'Logging In...',));
      try{
        final user=await AuthService.firebase().logInWithGoogle();
        emit(AuthStateLoggedOut(exception: null, isLoading: false));
        if(!user.isEmailVerified){
          emit(const AuthStateNeedsVerification(isLoading: false));
        }else{
          emit(AuthStateLoggedIn(user: user, isLoading: false,));
        }
      }on Exception catch(e){
        emit(AuthStateLoggedOut(exception: e,isLoading: false));
      }
    });
    // LogOut
    on<AuthEventLogOut>((event,emit)async{
      emit(const AuthStateLoggedOut(exception: null,isLoading: true, loadingText: 'Logging Out...'));
      try{
        await provider.logOut();
        emit(const AuthStateLoggedOut(exception: null,isLoading: false));
      }on Exception catch(e){
        emit(AuthStateLoggedOut(exception: e,isLoading: false));
      }
    });
    // Send email verification
    on<AuthEventSendEmailVerification>((event,emit)async{
      await provider.sendEmailVerification();
      emit(state);
    });
    // Register
    on<AuthEventRegister>((event,emit)async{
      emit(const AuthStateRegistering(isLoading: true, exception: null,loadingText: 'Registering...'));
      try{
        await provider.createUser(email: event.email, password: event.password);
        await provider.sendEmailVerification();
        emit(const AuthStateNeedsVerification(isLoading: false));
      }on Exception catch(e){
        emit(AuthStateRegistering(exception: e, isLoading: false,));
      }
    });
    //forgot password
    on<AuthEventForgotPassword>((event, emit) async {
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: false,
      ));
      final email = event.email;
      if (email == null) {
        return; // user just wants to go to forgot-password screen
      }

      // user wants to actually send a forgot-password email
      emit(const AuthStateForgotPassword(
        exception: null,
        hasSentEmail: false,
        isLoading: true,
      ));

      bool didSendEmail;
      Exception? exception;
      try {
        await provider.sendPasswordReset(toEmail: email);
        didSendEmail = true;
        exception = null;
      } on Exception catch (e) {
        didSendEmail = false;
        exception = e;
      }

      emit(AuthStateForgotPassword(
        exception: exception,
        hasSentEmail: didSendEmail,
        isLoading: false,
      ));
    });
  }
}