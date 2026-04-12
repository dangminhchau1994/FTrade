class WatchlistGroup {
  final String id;
  final String name;
  final List<String> symbols;
  final DateTime createdAt;
  final bool isAiGenerated;
  final String? briefDate;
  final String? sectorId;

  const WatchlistGroup({
    required this.id,
    required this.name,
    required this.symbols,
    required this.createdAt,
    required this.isAiGenerated,
    this.briefDate,
    this.sectorId,
  });

  WatchlistGroup copyWith({List<String>? symbols}) => WatchlistGroup(
        id: id,
        name: name,
        symbols: symbols ?? this.symbols,
        createdAt: createdAt,
        isAiGenerated: isAiGenerated,
        briefDate: briefDate,
        sectorId: sectorId,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'symbols': symbols,
        'createdAt': createdAt.toIso8601String(),
        'isAiGenerated': isAiGenerated,
        'briefDate': briefDate,
        'sectorId': sectorId,
      };

  factory WatchlistGroup.fromJson(Map<String, dynamic> json) => WatchlistGroup(
        id: json['id'] as String,
        name: json['name'] as String,
        symbols: List<String>.from(json['symbols'] as List),
        createdAt: DateTime.parse(json['createdAt'] as String),
        isAiGenerated: json['isAiGenerated'] as bool? ?? false,
        briefDate: json['briefDate'] as String?,
        sectorId: json['sectorId'] as String?,
      );
}
