
import 'dart:convert';
import '../services/problem_service.dart';
import 'refresh_token_repository.dart';
import '../models/problem_summary.dart';

class ProblemRepository {
  final _service = ProblemService();
  final _refresh = RefreshTokenRepository();

  Future<List<ProblemSummary>> getProblems({int page = 1, int limit = 20, String? difficulty}) async {
    final res = await _service.getProblems(page: page, limit: limit, difficulty: difficulty);
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final data = json['data'] as List<dynamic>? ?? [];
      return data.map((e) => ProblemSummary.fromJson(e)).toList();
    } else if (res.statusCode == 401) {
      final ok = await _refresh.refreshToken();
      if (ok) {
        final res2 = await _service.getProblems(page: page, limit: limit, difficulty: difficulty);
        if (res2.statusCode == 200) {
          final json = jsonDecode(res2.body);
          final data = json['data'] as List<dynamic>? ?? [];
          return data.map((e) => ProblemSummary.fromJson(e)).toList();
        }
      }
    }
    return [];
  }
}

