import 'package:arabic/features/home/data/model/progress_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProgressModel', () {
    test('should parse correctly when fields are null or formatted as integers', () {
      // The JSON provided by the user in the error log
      final json = {
        "success": true,
        "message": "Progress stats retrieved successfully",
        "data": {
          "percentage": 0,
          "completedLessonsCount": 0,
          "totalXp": 0,
          "activeDays": 0,
          "lastSync": null
        }
      };

      final model = ProgressModel.fromJson(json);

      expect(model.success, true);
      expect(model.data.percentage, 0.0);
      expect(model.data.completedLessonsCount, 0);
      expect(model.data.lastSync, null);
    });

    test('should parse correctly with full data', () {
      final json = {
        "success": true,
        "message": "Success",
        "data": {
          "percentage": 45.5,
          "completedLessonsCount": 10,
          "totalXp": 500,
          "activeDays": 5,
          "lastSync": "2024-03-07"
        }
      };

      final model = ProgressModel.fromJson(json);

      expect(model.data.percentage, 45.5);
      expect(model.data.lastSync, "2024-03-07");
    });
  });
}
