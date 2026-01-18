function batchUpdate(seriesData) {
  const chunkSize = 500;
  for (let i = 0; i < seriesData.length; i += chunkSize) {
    setTimeout(() => {
      chart.series[0].setData(seriesData.slice(i, i + chunkSize));
    }, i / chunkSize);
  }
}
