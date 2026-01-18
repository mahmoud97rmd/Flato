class WatchlistCleanGuard {
  static void clean(String symbol, Map cache) {
    cache.remove(symbol);
  }
}
