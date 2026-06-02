class VersionUtils {
  static int compareVersions(String v1, String v2) {
    try {
      final cleanV1 = v1.toLowerCase().replaceAll(RegExp(r'^[vV]'), '');
      final cleanV2 = v2.toLowerCase().replaceAll(RegExp(r'^[vV]'), '');

      List<String> parts1 = cleanV1.split('.');
      List<String> parts2 = cleanV2.split('.');

      int length = parts1.length > parts2.length ? parts1.length : parts2.length;

      for (int i = 0; i < length; i++) {
        String p1Str = i < parts1.length ? parts1[i] : '0';
        String p2Str = i < parts2.length ? parts2[i] : '0';

        bool p1IsNum = int.tryParse(p1Str) != null;
        bool p2IsNum = int.tryParse(p2Str) != null;

        if (p1IsNum && p2IsNum) {
          int p1Num = int.parse(p1Str);
          int p2Num = int.parse(p2Str);
          if (p1Num > p2Num) return 1;
          if (p1Num < p2Num) return -1;
        } else if (p1IsNum && !p2IsNum) {
          return 1;
        } else if (!p1IsNum && p2IsNum) {
          return -1;
        } else {
          int comparison = p1Str.compareTo(p2Str);
          if (comparison != 0) {
            return comparison;
          }
        }
      }
      return 0;
    } catch (e) {
      print('Error comparing versions "$v1" and "$v2": $e');
      return v1.compareTo(v2);
    }
  }
}