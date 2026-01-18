class BlocInitBarrier {
  bool chartReady = false;
  bool indicatorReady = false;

  bool get allReady => chartReady && indicatorReady;

  void setChartReady() => chartReady = true;
  void setIndicatorReady() => indicatorReady = true;
}
