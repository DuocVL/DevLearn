import 'package:devlearn/data/models/submission.dart';
import 'package:devlearn/data/repositories/submission_repository.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class SubmissionHistoryTab extends StatefulWidget {
  final String problemId;
  const SubmissionHistoryTab({super.key, required this.problemId});

  @override
  State<SubmissionHistoryTab> createState() => _SubmissionHistoryTabState();
}

class _SubmissionHistoryTabState extends State<SubmissionHistoryTab> {
  late Future<List<Submission>> _submissionsFuture;
  final SubmissionRepository _submissionRepository = SubmissionRepository();

  @override
  void initState() {
    super.initState();
    // Thêm ngôn ngữ tiếng Việt cho timeago
    timeago.setLocaleMessages('vi', timeago.ViMessages());
    _loadSubmissions();
  }

  void _loadSubmissions() {
    setState(() {
      _submissionsFuture = _submissionRepository.getSubmissions(problemId: widget.problemId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Submission>>(
      future: _submissionsFuture,
      builder: (context, snapshot) {
        // 1. Trạng thái đang tải
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. Trạng thái lỗi
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Lỗi tải lịch sử: ${snapshot.error}'),
            ),
          );
        }

        // 3. Không có dữ liệu hoặc danh sách rỗng
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'Chưa có lần nộp bài nào cho bài tập này.',
              textAlign: TextAlign.center,
            ),
          );
        }

        // 4. Hiển thị danh sách
        final submissions = snapshot.data!;
        return RefreshIndicator(
          onRefresh: () async => _loadSubmissions(),
          child: ListView.builder(
            itemCount: submissions.length,
            itemBuilder: (context, index) {
              final submission = submissions[index];
              return _buildSubmissionTile(context, submission);
            },
          ),
        );
      },
    );
  }

  Widget _buildSubmissionTile(BuildContext context, Submission submission) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(submission.status);

    return ListTile(
      leading: Icon(Icons.history, color: theme.colorScheme.secondary),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            submission.status,
            style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
          ),
          Text(
            submission.language,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
      subtitle: Text(
        'Nộp ${timeago.format(submission.createdAt, locale: 'vi')}',
      ),
      onTap: () {
        // TODO: Hiển thị chi tiết lần nộp bài, bao gồm code và kết quả chi tiết
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chức năng xem chi tiết đang được phát triển!')),
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Accepted':
        return Colors.green;
      case 'Wrong Answer':
        return Colors.red;
      case 'Runtime Error':
        return Colors.orange;
      case 'Time Limit Exceeded':
        return Colors.deepOrange;
      case 'Pending':
      case 'Running':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
