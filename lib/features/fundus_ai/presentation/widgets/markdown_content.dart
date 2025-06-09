import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:sugeye/app/themes/app_colors.dart';

class MarkdownContent extends StatelessWidget {
  final String content;

  const MarkdownContent({required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    // Convert markdown to HTML
    final html = md.markdownToHtml(
      content,
      extensionSet: md.ExtensionSet.gitHubFlavored,
    );
    return Html(
      data: html,
      style: {
        "body": Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontSize: FontSize(16),
          color: AppColors.white,
        ),
        "p": Style(margin: Margins.only(bottom: 8)),
        "h1, h2, h3, h4, h5, h6": Style(
          fontWeight: FontWeight.bold,
          margin: Margins.only(bottom: 8, top: 8),
          color: AppColors.white,
        ),
        "ul, ol": Style(margin: Margins.only(left: 16, bottom: 8)),
        "li": Style(margin: Margins.only(bottom: 4)),
        "code": Style(
          backgroundColor: Colors.grey.shade200,
          padding: HtmlPaddings.symmetric(horizontal: 4, vertical: 2),
          fontFamily: 'monospace',
          color: Colors.black87,
        ),
        "pre": Style(
          backgroundColor: Colors.grey.shade100,
          padding: HtmlPaddings.all(12),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.black87,
        ),
        "hr": Style(
          // Horizontal rule styling for "---"
          margin: Margins.symmetric(
            vertical: 8,
          ), // Reduced from default spacing
          border: const Border(
            top: BorderSide(color: AppColors.white, width: 1),
          ),
          height: Height(1),
        ),
        "blockquote": Style(
          border: const Border(
            left: BorderSide(color: AppColors.white, width: 4),
          ),
          padding: HtmlPaddings.only(left: 12),
          margin: Margins.symmetric(vertical: 8),
          fontStyle: FontStyle.italic,
          color: AppColors.white,
        ),
      },
    );
  }
}
