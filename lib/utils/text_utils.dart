class TextUtils {
  /// Limpia una cadena de texto de las etiquetas HTML más comunes.
  static String stripHtml(String? htmlString) {
    if (htmlString == null) return '';
    
    final withLineBreaks = htmlString
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</li>', caseSensitive: false), '')
        .replaceAll(RegExp(r'</p>', caseSensitive: false), '');
        
    final withListItems = withLineBreaks.replaceAll(
      RegExp(r'<li>', caseSensitive: false),
      '- ',
    );
    
    final withoutTags = withListItems.replaceAll(RegExp(r'<[^>]*>'), '');
    
    final decoded = withoutTags
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&nbsp;', ' ');

    final cleanedNewlines = decoded.replaceAll(RegExp(r'(\n\s*){2,}'), '\n');

    return cleanedNewlines.trim();
  }
}