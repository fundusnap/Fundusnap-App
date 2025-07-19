import 'package:equatable/equatable.dart';
import 'package:sugeye/features/prediction/domain/entities/bounding_box.dart';

class DetectionArtifact extends Equatable {
  final String className;
  final double confidence;
  final BoundingBox box;

  const DetectionArtifact({
    required this.className,
    required this.confidence,
    required this.box,
  });

  @override
  List<Object?> get props => [className, confidence, box];

  factory DetectionArtifact.fromJson(Map<String, dynamic> json) {
    try {
      return DetectionArtifact(
        className: json['class_name'] as String,
        confidence: (json['confidence'] as num).toDouble(),
        box: BoundingBox.fromJson(json['box'] as Map<String, dynamic>),
      );
    } catch (e) {
      throw FormatException(
        'Failed to parse DetectionArtifact from JSON: $json',
        e,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'class_name': className,
      'confidence': confidence,
      'box': box.toJson(),
    };
  }
}
