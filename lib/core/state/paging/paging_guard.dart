class PagingGuard {
  final Set<int> loadedPages = {};

  bool canLoad(int page) {
    if (loadedPages.contains(page)) return false;
    loadedPages.add(page);
    return true;
  }
}
