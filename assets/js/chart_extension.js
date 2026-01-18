// تُستدعى من Flutter
function addIndicatorSeries(name, dataPoints) {
  const series = chart.addLineSeries({ color: '#00bcd4' });
  series.setData(dataPoints);
}
