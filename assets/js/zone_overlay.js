// يستدعيها Flutter عندما يحصل تنبيه
function highlightZone(fromTs, toTs, color = '#ffc107') {
  chart.addAreaSeries({
    topColor: color,
    bottomColor: color + "33",
    lineColor: color,
    lineWidth: 1,
  }).setData([
    { time: fromTs, value: 1 },
    { time: toTs, value: 1 }
  ]);
}
