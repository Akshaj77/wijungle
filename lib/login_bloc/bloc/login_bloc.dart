import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:wijungle/constants/constants.dart';
import 'package:wijungle/data/success.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({required this.dio}) : super(LoginInitial()) {
    on<OnLoginEvent>(_onLoginEvent);
  }

  final Dio dio;

  Future<void> _onLoginEvent(OnLoginEvent event,Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try{
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    return client;
  };
      final response = await dio.post(
        BasicApiUrl().BASEURL,
        queryParameters: {
          'type': 'login',
          'username': event.userName,
          'password': event.password
          
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json'
          },
        )
      );
      final token = response.data['key'];
      print(response.data);
      if (response.statusCode == 200) {
         emit(LoginLoaded(token: token));
      }
    }
    catch(e) {
      print(e);
      emit(LoginError(error: e.toString()));
    }

      
  }

}
