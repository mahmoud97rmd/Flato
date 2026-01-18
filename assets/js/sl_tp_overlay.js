function drawSLTP(slTime, slPrice, tpTime, tpPrice) {
  chart.createPriceLine({
    price: slPrice,
    color: 'red',
    lineWidth: 1,
    lineStyle: LightweightCharts.LineStyle.Dashed,
  });
  chart.createPriceLine({
    price: tpPrice,
    color: 'green',
    lineWidth: 1,
  });
}
