String formatNumber(double value) {
  if (value >= 1000000) {
    return '${(value / 1000000).toStringAsFixed(1)}M';
  } else if (value >= 1000) {
    return '${(value / 1000).toStringAsFixed(0)},${(value % 1000).toStringAsFixed(0).padLeft(3, '0')}';
  }
  return value.toStringAsFixed(0);
}
