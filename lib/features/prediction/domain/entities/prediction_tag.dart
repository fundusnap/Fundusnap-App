import 'package:equatable/equatable.dart';

class PredictionTag extends Equatable {
  final double probability;
  final String tagId;
  final String tagName;

  const PredictionTag({
    required this.probability,
    required this.tagId,
    required this.tagName,
  });

  @override
  List<Object?> get props => [probability, tagId, tagName];

  factory PredictionTag.fromJson(Map<String, dynamic> json) {
    try {
      return PredictionTag(
        probability: (json['probability'] as num).toDouble(),
        tagId: json['tagId'] as String,
        tagName: json['tagName'] as String,
      );
    } catch (e) {
      throw FormatException(
        'Failed to parse PredictionTag from JSON: $json',
        e,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {'probability': probability, 'tagId': tagId, 'tagName': tagName};
  }
}
