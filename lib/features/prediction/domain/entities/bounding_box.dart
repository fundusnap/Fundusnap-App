import 'package:equatable/equatable.dart';

class BoundingBox extends Equatable {
  final int x1;
  final int y1;
  final int x2;
  final int y2;

  const BoundingBox({
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
  });

  @override
  List<Object?> get props => [x1, y1, x2, y2];

  factory BoundingBox.fromJson(Map<String, dynamic> json) {
    return BoundingBox(
      x1: json['x1'] as int,
      y1: json['y1'] as int,
      x2: json['x2'] as int,
      y2: json['y2'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'x1': x1, 'y1': y1, 'x2': x2, 'y2': y2};
  }
}
