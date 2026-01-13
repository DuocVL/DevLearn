import 'package:devlearn/data/models/problem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/theme_map.dart';

class CodeEditor extends StatefulWidget {
  final List<StarterCode> starterCode;
  final Function(String language, String code) onSubmit;

  const CodeEditor({super.key, required this.starterCode, required this.onSubmit});

  @override
  State<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  late String _selectedLanguage;
  late TextEditingController _codeController;
  late StarterCode _currentStarterCode;

  @override
  void initState() {
    super.initState();
    _currentStarterCode = widget.starterCode.first;
    _selectedLanguage = _currentStarterCode.language;
    _codeController = TextEditingController(text: _currentStarterCode.code);
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _onLanguageChanged(String? newLanguage) {
    if (newLanguage != null) {
      setState(() {
        _selectedLanguage = newLanguage;
        _currentStarterCode = widget.starterCode.firstWhere((sc) => sc.language == newLanguage);
        _codeController.text = _currentStarterCode.code;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        _buildToolbar(theme),
        Expanded(
          child: _buildCodeInput(theme),
        ),
        _buildActionBar(theme),
      ],
    );
  }

  Widget _buildToolbar(ThemeData theme) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        children: [
          DropdownButton<String>(
            value: _selectedLanguage,
            onChanged: _onLanguageChanged,
            items: widget.starterCode
                .map((sc) => DropdownMenuItem(
                      value: sc.language,
                      child: Text(sc.language.toUpperCase()),
                    ))
                .toList(),
            underline: const SizedBox(),
            style: theme.textTheme.bodyMedium,
            dropdownColor: theme.cardColor,
          ),
        ],
      ),
    );
  }

  Widget _buildCodeInput(ThemeData theme) {
    final codeTheme = theme.brightness == Brightness.dark 
        ? themeMap['atom-one-dark']! 
        : themeMap['atom-one-light']!;

    return Container(
      color: codeTheme['root']?.backgroundColor,
      child: Stack(
        children: [
          HighlightView(
            _codeController.text,
            language: _selectedLanguage,
            theme: codeTheme, 
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
            textStyle: const TextStyle(fontFamily: 'monospace', fontSize: 14),
          ),
          TextField(
            controller: _codeController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            autocorrect: false,
            enableSuggestions: false,
            // SỬA: Dùng đúng tên thuộc tính là `cursorColor`
            cursorColor: theme.brightness == Brightness.dark ? Colors.white : Colors.black, 
            style: const TextStyle(
              fontFamily: 'monospace', 
              fontSize: 14, 
              color: Colors.transparent,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
            onChanged: (value) => setState(() {}),
          ),
        ],
      ),
    );
  }

  Widget _buildActionBar(ThemeData theme) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () { /* TODO: Implement Run Code */ },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade700,
              foregroundColor: Colors.white,
            ),
            child: const Text('Chạy thử'),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => widget.onSubmit(_selectedLanguage, _codeController.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Nộp bài'),
          ),
        ],
      ),
    );
  }
}
