import 'package:devlearn/data/repositories/post_repository.dart';
import 'package:flutter/material.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _tagsController = TextEditingController();
  final _contentController = TextEditingController();
  final _repo = PostRepository();
  bool _anonymous = false;
  bool _submitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _tagsController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    final tags = _tagsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    setState(() => _submitting = true);

    try {
      await _repo.addPost(
        _titleController.text.trim(),
        _contentController.text.trim(),
        tags,
        _anonymous,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã tạo bài viết thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString().replaceFirst("Exception: ", "")}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo bài viết'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Tiêu đề',
                  hintText: 'Nhập tiêu đề bài viết',
                ),
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? 'Tiêu đề không được để trống' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags',
                  hintText: 'Phân tách các tags bằng dấu phẩy ( , )',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                minLines: 8,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Nội dung',
                  hintText: 'Nhập nội dung bài viết của bạn...',
                  alignLabelWithHint: true,
                ),
                validator: (value) =>
                    (value == null || value.trim().isEmpty) ? 'Nội dung không được để trống' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Switch(
                    value: _anonymous,
                    onChanged: (value) => setState(() => _anonymous = value),
                  ),
                  const SizedBox(width: 8),
                  const Text('Đăng với tư cách ẩn danh'),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: _submitting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.send),
                label: Text(_submitting ? 'Đang gửi...' : 'Đăng bài'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
