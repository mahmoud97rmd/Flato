function drawSLTPWhenReady(sl, tp) {
  if (!window.chart) {
    setTimeout(() => drawSLTPWhenReady(sl, tp), 50);
    return;
  }
  drawSLTP(sl, tp);
}
