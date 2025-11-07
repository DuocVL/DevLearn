import 'package:intl/intl.dart';

String timeAgo(DateTime date) {
  final diff = DateTime.now().difference(date);
  if (diff.inMinutes < 1) return 'Vừa xong';
  if (diff.inHours < 1) return '${diff.inMinutes} phút trước';
  if (diff.inDays < 1) return '${diff.inHours} giờ trước';
  return DateFormat('dd/MM/yyyy').format(date);
}