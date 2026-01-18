class PagingTracker {
  final Set<int> _loadedPages = {};

  bool canLoad(int page) {
    if (_loadedPages.contains(page)) return false;
    _loadedPages.add(page);
    return true;
  }
}
