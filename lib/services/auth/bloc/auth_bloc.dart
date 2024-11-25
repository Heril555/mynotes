import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';

import '../auth_service.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  AuthBloc(AuthService provider):super(const AuthStateLoading()){
    on<AuthEventInitialize>((event,emit) async {
      await provider.initialize();
      final user = provider.currentUser;
      if(user==null){
        emit(const AuthStateLoggedOut());
      }else if(!user.isEmailVerified){
        emit(const AuthStateNeedsVerification());
      } else{
        emit(AuthStateLoggedIn(user));
      }
    });
    // LogIn
    on<AuthEventLogIn>((event, emit)async{
      emit(const AuthStateLoading());
      final email = event.email;
      final password = event.password;
      try{
        final user=await provider.logIn(email: email, password: password);
        emit(AuthStateLoggedIn(user));
      }on Exception catch(e){
        emit(AuthStateLoginFailure(e));
      }
    });
    // LogOut
    on<AuthEventLogOut>((event,emit)async{
      emit(const AuthStateLoading());
      try{
        await provider.logOut();
        emit(const AuthStateLoggedOut());
      }on Exception catch(e){
        emit(AuthStateLogoutFailure(e));
      }
    });
  }
}