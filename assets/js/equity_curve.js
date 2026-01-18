function drawEquityCurve(points) {
  const series = chart.addLineSeries({ color: '#2196f3' });
  series.setData(points);
}
