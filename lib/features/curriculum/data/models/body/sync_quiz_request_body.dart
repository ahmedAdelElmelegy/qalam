class SyncQuizRequestBody {
  final List<Completion> completions;

  SyncQuizRequestBody({required this.completions});

  factory SyncQuizRequestBody.fromJson(Map<String, dynamic> json) {
    return SyncQuizRequestBody(
      completions: List<Completion>.from(
        json['completions'].map((x) => Completion.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {'completions': completions.map((x) => x.toJson()).toList()};
  }
}

class Completion {
  final String id;
  final int dbId;
  final String type;
  final int xpReward;
  final DateTime completedAt;

  Completion({
    required this.id,
    required this.dbId,
    required this.type,
    required this.xpReward,
    required this.completedAt,
  });

  factory Completion.fromJson(Map<String, dynamic> json) {
    return Completion(
      id: json['id'],
      dbId: json['dbId'],
      type: json['type'],
      xpReward: json['xpReward'],
      completedAt: DateTime.parse(json['completedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dbId': dbId,
      'type': type,
      'xpReward': xpReward,
      'completedAt': completedAt.toIso8601String(),
    };
  }
}
