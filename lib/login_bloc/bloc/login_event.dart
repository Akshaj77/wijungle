part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class OnLoginEvent extends LoginEvent{
  final String userName;
  final String password;

  OnLoginEvent({required this.userName,required this.password});
}
