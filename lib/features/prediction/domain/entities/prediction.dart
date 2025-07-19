import 'package:equatable/equatable.dart';
import 'package:sugeye/features/prediction/domain/entities/prediction_tag.dart'; // Import PredictionTag
import 'package:sugeye/features/prediction/domain/entities/detection_artifact.dart'; // Import PredictionTag

class Prediction extends Equatable {
  final String id;
  final String project;
  final String iteration;
  final DateTime created;
  final List<PredictionTag> predictions;
  final String name;
  final String description;
  final String imageURL;
  final String detectionURL;
  final List<DetectionArtifact> detectionArtifacts;

  const Prediction({
    required this.id,
    required this.project,
    required this.iteration,
    required this.created,
    required this.predictions,
    required this.name,
    required this.description,
    required this.imageURL,
    required this.detectionURL,
    required this.detectionArtifacts,
  });

  @override
  List<Object?> get props => [
    id,
    project,
    iteration,
    created,
    predictions,
    name,
    description,
    imageURL,
    detectionURL,
    detectionArtifacts,
  ];

  factory Prediction.fromJson(Map<String, dynamic> json) {
    try {
      final predictionsList = (json['predictions'] as List)
          .map(
            (tagJson) =>
                PredictionTag.fromJson(tagJson as Map<String, dynamic>),
          )
          .toList();

      final artifactsList = (json['detectionArtifacts'] as List)
          .map(
            (artifactJson) => DetectionArtifact.fromJson(
              artifactJson as Map<String, dynamic>,
            ),
          )
          .toList();

      return Prediction(
        id: json['id'] as String,
        project: json['project'] as String,
        iteration: json['iteration'] as String,
        created: DateTime.parse(json['created'] as String),
        predictions: predictionsList,
        name: json['name'] as String,
        description: json['description'] as String,
        imageURL: json['imageURL'] as String,
        detectionURL: json['detectionURL'] as String,
        detectionArtifacts: artifactsList,
      );
    } catch (e) {
      throw FormatException('Failed to parse Prediction from JSON: $json', e);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'project': project,
      'iteration': iteration,
      'created': created.toIso8601String(),
      'predictions': predictions.map((tag) => tag.toJson()).toList(),
      'name': name,
      'description': description,
      'imageURL': imageURL,
      'detectionURL': detectionURL,
      'detectionArtifacts': detectionArtifacts
          .map((artifact) => artifact.toJson())
          .toList(),
    };
  }
}
