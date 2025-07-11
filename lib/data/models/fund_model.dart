//Este el plano de nuestros datos
class Fund {
  final String id;
  final String name;
  final double minimumAmount;
  final String category;
  final String displayName;
  bool isSubscribed;
  double? subscribedAmount;

  Fund({
    required this.id,
    required this.name,
    required this.minimumAmount,
    required this.category,
    required this.displayName,
    this.isSubscribed = false,
    this.subscribedAmount,
  });

  factory Fund.fromJson(Map<String, dynamic> json) {
    return Fund(
      id: json['id'].toString(), // Convertimos el id a String para más flexibilidad.
      name: json['name'],
      minimumAmount: (json['minimumAmount'] as num).toDouble(),
      category: json['category'],
      displayName: json['displayName'],
    );
  }
}