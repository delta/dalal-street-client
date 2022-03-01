import 'package:path_to_regexp/path_to_regexp.dart';

extension RegexUtil on List<String> {
  bool hasMatch(String path) {
    for (var item in this) {
      final regex = pathToRegExp(item);
      if (regex.hasMatch(path)) return true;
    }
    return false;
  }
}
