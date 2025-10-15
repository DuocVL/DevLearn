import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/refresh_token_service.dart';

class RefreshTokenRepository {

  final _refreshTokenService = RefreshTokenService();
  final _storge = const FlutterSecureStorage();

  Future<bool> refreshToken() async {
    final res = await _refreshTokenService.refreshToken();

    if(res.statusCode == 200){
      final data = jsonDecode(res.body);

      await _storge.write(key: 'asset_token', value: data['assetToken']);
      return true;
    }else{
      return false;
    }
  }
  
}