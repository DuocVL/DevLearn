import 'package:http/http.dart' as http;

class AuthService {

  final baseurl = 'http://localhost:4000/auth';

  Future<http.Response> login (String email, String password) async{
      final url = Uri.parse('$baseurl/login');
      final reponse = http.post(
        url,
        body: {
          email,
          password,
        }
      );

      return reponse;
  }

}