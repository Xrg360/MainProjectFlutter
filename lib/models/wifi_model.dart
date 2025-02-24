class WifiModel {
  final String name;
  final int signalStrength;

  WifiModel({required this.name, required this.signalStrength});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'signalStrength': signalStrength,
    };
  }
}
