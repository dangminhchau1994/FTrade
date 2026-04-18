class ForeignFlowStats {
  final double buyVolume;
  final double sellVolume;
  final double netVolume;
  final double buyValue;
  final double sellValue;
  final double netValue;
  final DateTime date;

  const ForeignFlowStats({
    required this.buyVolume,
    required this.sellVolume,
    required this.netVolume,
    required this.buyValue,
    required this.sellValue,
    required this.netValue,
    required this.date,
  });
}
