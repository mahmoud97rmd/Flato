window.onerror = function(message, source, lineno, colno, error) {
  if (message.includes('ResizeObserver')) return true;
  return false;
};
