import 'dart:convert';

import '../services/auth_service.dart' ;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {

  final _authService = AuthService();
  final _storage = const FlutterSecureStorage();

  Future<bool> login(String email, String password) async{
    final res = await _authService.login(email, password);

    if(res.statusCode == 200){
      final data = jsonDecode(res.body);

      await _storage.write( key: 'asset_token', value: data['assetToken'] );
      await _storage.write( key: 'refresh_token', value: data['refreshToken'] );
      return true;
    }else {
      return false;
    }

  }

  Future<bool> logout() async {
    final res = await _authService.logout();
    

    if(res.statusCode == 200){
      await _storage.deleteAll();

      return true;
    }else{
      return false;
    }
  }

}