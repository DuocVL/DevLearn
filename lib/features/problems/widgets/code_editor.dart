import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';
// SỬA: Import theme phổ biến và có sẵn
import 'package:flutter_highlight/themes/atom-one-dark.dart'; 
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/javascript.dart';

class CodeEditor extends StatefulWidget {
  final Map<String, String> starterCode;
  final Function(String language, String code) onSubmit;

  const CodeEditor({
    super.key,
    required this.starterCode,
    required this.onSubmit,
  });

  @override
  State<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  late String _selectedLanguage;
  CodeController? _codeController;

  @override
  void initState() {
    super.initState();
    if (widget.starterCode.isNotEmpty) {
      _selectedLanguage = widget.starterCode.keys.first;
      _initializeController();
    }
  }

  // SỬA: Không cần truy cập context ở đây nữa
  void _initializeController() {
    final sourceCode = widget.starterCode[_selectedLanguage] ?? '';
    final languageMode = {
      'cpp': cpp,
      'java': java,
      'python': python,
      'javascript': javascript,
    }[_selectedLanguage];

    _codeController = CodeController(
      text: sourceCode,
      language: languageMode,
      // SỬA: Xóa bỏ thuộc tính theme không hợp lệ
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Nếu controller chưa được khởi tạo, hãy thử lại
    // Điều này có thể xảy ra nếu initState chạy trước khi context sẵn sàng
    if (_codeController == null && widget.starterCode.isNotEmpty) {
      _initializeController();
    }
  }

  @override
  void dispose() {
    _codeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_codeController == null) {
      return const Center(child: Text("Đang tải trình soạn thảo..."));
    }

    final theme = Theme.of(context);
    // SỬA: Xác định theme cho code editor ngay trong hàm build
    final codeTheme = theme.brightness == Brightness.dark
        ? atomOneDarkTheme
        : atomOneLightTheme;

    return Column(
      children: [
        _buildLanguageSelector(theme),
        Expanded(
          child: CodeTheme(
            // SỬA: Truyền theme đã xác định vào CodeTheme
            data: CodeThemeData(styles: codeTheme),
            child: SingleChildScrollView(
              child: CodeField(
                controller: _codeController!,
                textStyle: const TextStyle(fontFamily: 'monospace', fontSize: 14),
                minLines: 15,
                expands: false,
              ),
            ),
          ),
        ),
        _buildActionButtons(theme),
      ],
    );
  }

  Widget _buildLanguageSelector(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLanguage,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down),
          items: widget.starterCode.keys.map((String language) {
            return DropdownMenuItem<String>(
              value: language,
              child: Text(
                language.toUpperCase(),
                style: theme.textTheme.labelLarge,
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null && newValue != _selectedLanguage) {
              setState(() {
                _selectedLanguage = newValue;
                _codeController?.dispose();
                _initializeController();
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: const Text('Chạy thử'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chức năng Chạy thử đang được phát triển!')),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.onSurface,
                side: BorderSide(color: theme.colorScheme.outline),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.send),
              label: const Text('Nộp bài'),
              onPressed: () {
                if (_codeController != null) {
                  widget.onSubmit(_selectedLanguage, _codeController!.text);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
