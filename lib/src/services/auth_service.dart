import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:realtime_chat/src/global/environment.dart';
import 'package:realtime_chat/src/models/error_response.dart';
import 'package:realtime_chat/src/models/login_response.dart';
import 'package:realtime_chat/src/models/user.dart';

class AuthService with ChangeNotifier {  

  User user;
  bool _authenticating = false;
  final _storage = new FlutterSecureStorage();

  bool get authenticating => this._authenticating;
  set authenticating ( bool value ) {
    this._authenticating = value;
    notifyListeners();
  }

  // Getters del token de forma estatica
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: "token");
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: "token");
  }


  Future<String> login( String email, String password ) async {

    this.authenticating = true;

    final data = {
      "email": email,
      "password": password
    };

    final resp = await http.post( "${ Environment.apiUrl }/login",
      body: jsonEncode(data),
      headers: { "Content-Type": "application/json" }
    );

    this.authenticating = false;
    if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      this.user = loginResponse.user;

      // Guardar token en lugar seguro
      await this._saveToken( loginResponse.token );

      return  "ok";
    } else {
      final errorResponse = errorResponseFromJson( resp.body );
      return errorResponse.msg;
    }
  }

  Future<String> register( String name, String email, String password ) async {

    this.authenticating = true;

    final data = {
      "name": name,
      "email": email,
      "password": password
    };

    final resp = await http.post( "${ Environment.apiUrl }/login/new",
      body: jsonEncode(data),
      headers: { "Content-Type": "application/json" }
    );

    this.authenticating = false;
    if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      this.user = loginResponse.user;

      // Guardar token en lugar seguro
      await this._saveToken( loginResponse.token );

      return "ok";
    } else {
      final errorResponse = errorResponseFromJson( resp.body );
      return errorResponse.msg;
    }
  }

  Future<bool> isLoggedIn() async {

    final token = await this._storage.read(key: "token");
    
    final resp = await http.get( "${ Environment.apiUrl }/login/renew",
      headers: { 
        "Content-Type": "application/json",
        "x-token": token
      }
    );

    if ( resp.statusCode == 200 ) {
      final loginResponse = loginResponseFromJson( resp.body );
      this.user = loginResponse.user;

      // Guardar token en lugar seguro
      await this._saveToken( loginResponse.token );

      return true;
    } else {
      this.logout();
      return false;
    }
  }

  Future _saveToken( String token ) async {
    return await _storage.write(key: "token", value: token);
  }

  Future logout() async {
    await _storage.delete(key: "token");
  }

}