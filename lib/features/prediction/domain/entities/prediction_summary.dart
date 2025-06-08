import 'package:equatable/equatable.dart';

class PredictionSummary extends Equatable {
  final String id;
  final String name;
  final String description;
  final DateTime created;
  final String imageURL;

  const PredictionSummary({
    required this.id,
    required this.name,
    required this.description,
    required this.created,
    required this.imageURL,
  });

  @override
  List<Object?> get props => [id, name, description, created, imageURL];

  factory PredictionSummary.fromJson(Map<String, dynamic> json) {
    try {
      return PredictionSummary(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        created: DateTime.parse(json['created'] as String),
        imageURL: json['imageURL'] as String,
      );
    } catch (e) {
      throw FormatException(
        'Failed to parse PredictionSummary from JSON: $json',
        e,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'created': created.toIso8601String(),
      'imageURL': imageURL,
    };
  }
}
