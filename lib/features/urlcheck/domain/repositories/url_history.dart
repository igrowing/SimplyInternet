/// Store of website addresses the user has checked before, kept so the URL
/// field can offer them back as suggestions. Newest first.
abstract class UrlHistory {
  /// Every remembered address, most-recently checked first.
  List<String> entries();

  /// Record [url] as the newest entry, moving it to the front if it was
  /// already there. A blank string is ignored.
  Future<void> remember(String url);
}
