import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

class BBCodeRenderer extends StatelessWidget {
  final String data;
  final TextStyle? defaultStyle;

  const BBCodeRenderer({super.key, required this.data, this.defaultStyle});

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle =
        defaultStyle ??
        Theme.of(context).textTheme.bodyMedium ??
        const TextStyle();
    final decodedData = data
        .replaceAll('&#92;', r'\')
        .replaceAll('&gt;', '>')
        .replaceAll('&lt;', '<')
        .replaceAll('&amp;', '&');

    final widgets = _parseBBCode(context, decodedData);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets.map((widget) {
        if (widget is RichText) {
          return DefaultTextStyle(style: defaultTextStyle, child: widget);
        }
        return widget;
      }).toList(),
    );
  }

  List<Widget> _parseBBCode(BuildContext context, String text) {
    final List<Widget> widgets = [];
    final regex = RegExp(
      r'(\[center\][\s\S]*?\[/center\]|\[left\][\s\S]*?\[/left\]|\[list(?:=1)?\][\s\S]*?\[/list\]|\[img\][\s\S]*?\[/img\])',
      caseSensitive: false,
    );

    text.splitMapJoin(
      regex,
      onMatch: (Match match) {
        final String matchText = match.group(0)!;
        final String lowerCaseMatch = matchText.toLowerCase();

        if (lowerCaseMatch.startsWith('[center]')) {
          final content = matchText.substring(8, matchText.length - 9);
          widgets.add(
            Center(child: Column(children: _parseBBCode(context, content))),
          );
        } else if (lowerCaseMatch.startsWith('[left]')) {
          final content = matchText.substring(6, matchText.length - 7);
          widgets.add(
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _parseBBCode(context, content),
              ),
            ),
          );
        } else if (lowerCaseMatch.startsWith('[list')) {
          final bool isOrdered = lowerCaseMatch.startsWith('[list=1]');
          final int startIndex = matchText.indexOf(']') + 1;
          final content = matchText.substring(startIndex, matchText.length - 7);
          widgets.add(_buildList(context, content, isOrdered: isOrdered));
        } else if (lowerCaseMatch.startsWith('[img]')) {
          final url = matchText.substring(5, matchText.length - 6).trim();
          widgets.add(
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Image.network(
                url,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image_outlined, color: Colors.grey),
              ),
            ),
          );
        }
        return '';
      },
      onNonMatch: (String text) {
        if (text.trim().isEmpty) return '';

        final itemParts = text.split(RegExp(r'\[\*\]', caseSensitive: false));

        if (itemParts.first.trim().isNotEmpty) {
          widgets.add(_buildRichText(context, itemParts.first));
        }

        if (itemParts.length > 1) {
          for (final itemText in itemParts.skip(1)) {
            if (itemText.trim().isNotEmpty) {
              widgets.add(_buildStandaloneListItem(context, itemText.trim()));
            }
          }
        }
        return '';
      },
    );

    return widgets;
  }

  Widget _buildList(BuildContext context, String content, {bool isOrdered = false}) {
    final items = content.split(RegExp(r'\[\*\]', caseSensitive: false));
    if (items.isEmpty) return const SizedBox.shrink();

    final validItems = items.where((item) => item.trim().isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: validItems.asMap().entries.map((entry) {
        final index = entry.key;
        final itemText = entry.value;
        final String bullet = isOrdered ? "${index + 1}." : "•";

        return Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 2.0, bottom: 2.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0, top: 2.0),
                child: Text(
                  bullet,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _parseBBCode(context, itemText.trim()),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStandaloneListItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 2.0, bottom: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 8.0, top: 2.0),
            child: Text("•", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: _buildRichText(context, text)),
        ],
      ),
    );
  }

  Widget _buildRichText(BuildContext context, String text) {
    final List<TextSpan> spans = [];
    final List<TextStyle> styleStack = [const TextStyle()];
    final List<GestureRecognizer?> recognizerStack = [null];

    final regex = RegExp(
      r'\[\/?(b|u|i|s|color|size|url|font)(?:=([^\]]*))?\]',
      caseSensitive: false,
    );

    text.splitMapJoin(
      regex,
      onMatch: (Match match) {
        final tagName = match.group(1)?.toLowerCase();
        final tagValue = match.group(2);
        final isClosingTag = match.group(0)!.startsWith('[/');

        if (isClosingTag) {
          if (styleStack.length > 1) styleStack.removeLast();
          if (recognizerStack.length > 1) recognizerStack.removeLast();
        } else {
          TextStyle currentStyle = styleStack.last;
          GestureRecognizer? currentRecognizer = recognizerStack.last;

          switch (tagName) {
            case 'b':
              currentStyle = currentStyle.copyWith(fontWeight: FontWeight.bold);
              break;
            case 'u':
              currentStyle = currentStyle.copyWith(
                decoration: TextDecoration.underline,
              );
              break;
            case 'i':
              currentStyle = currentStyle.copyWith(fontStyle: FontStyle.italic);
              break;
            case 's':
              currentStyle = currentStyle.copyWith(
                decoration: TextDecoration.lineThrough,
              );
              break;
            case 'color':
              final color = _hexToColor(tagValue);
              if (color != null) {
                currentStyle = currentStyle.copyWith(color: color);
              }
              break;
            case 'size':
              final fontSize = _sizeToFontSize(tagValue);
              if (fontSize != null) {
                currentStyle = currentStyle.copyWith(fontSize: fontSize);
              }
              break;
            case 'url':
              if (tagValue != null) {
                currentRecognizer = TapGestureRecognizer()
                  ..onTap = () async {
                    try {
                      final url = Uri.parse(tagValue);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    } catch (e) {
                      print('Could not launch URL $tagValue: $e');
                    }
                  };
                currentStyle = currentStyle.copyWith(
                  color: Colors.lightBlueAccent,
                  decoration: TextDecoration.underline,
                );
              }
              break;
            case 'font':
              if (tagValue != null) {
                currentStyle = currentStyle.copyWith(
                  fontFamily: tagValue.replaceAll("'", "").replaceAll('"', ""),
                );
              }
              break;
          }
          styleStack.add(currentStyle);
          recognizerStack.add(currentRecognizer);
        }
        return '';
      },
      onNonMatch: (String text) {
        if (text.isNotEmpty) {
          spans.add(
            TextSpan(
              text: text,
              style: styleStack.last,
              recognizer: recognizerStack.last,
            ),
          );
        }
        return '';
      },
    );

    return RichText(
      text: TextSpan(
        children: spans,
        style: defaultStyle ?? Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  Color? _hexToColor(String? hex) {
    if (hex == null) return null;
    final hexString = hex.startsWith('#') ? hex.substring(1) : hex;
    if (hexString.length == 6) {
      return Color(int.parse('FF$hexString', radix: 16));
    }
    return null;
  }

  double? _sizeToFontSize(String? size) {
    if (size == null) return null;
    final sizeNum = int.tryParse(size);
    if (sizeNum == null) return null;
    switch (sizeNum) {
      case 1: return 10.0;
      case 2: return 12.0;
      case 3: return 14.0;
      case 4: return 16.0;
      case 5: return 20.0;
      case 6: return 24.0;
      case 7: return 32.0;
      default: return 14.0;
    }
  }
}