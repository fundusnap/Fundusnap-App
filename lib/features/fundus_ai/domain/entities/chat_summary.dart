import 'package:equatable/equatable.dart';

class ChatSummary extends Equatable {
  final String id;
  final String predictionID;
  final String highlight;
  final DateTime lastUpdated;

  const ChatSummary({
    required this.id,
    required this.predictionID,
    required this.highlight,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [id, predictionID, highlight, lastUpdated];

  factory ChatSummary.fromJson(Map<String, dynamic> json) {
    try {
      return ChatSummary(
        id: json['id'] as String,
        predictionID: json['predictionID'] as String,
        highlight: json['highlight'] as String,
        lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      );
    } catch (e) {
      throw FormatException('Failed to parse ChatSummary from JSON: $json', e);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'predictionID': predictionID,
      'highlight': highlight,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
