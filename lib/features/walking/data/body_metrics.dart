import 'package:vireo/core/services/hive_service.dart';

({double heightCm, double weightKg}) readBodyMetrics() {
  var height = 170.0;
  var weight = 75.0;
  if (!HiveService.isInitialized) return (heightCm: height, weightKg: weight);
  final profile = HiveService.cacheBox.get('guest_profile');
  if (profile is Map) {
    height = (profile['height_cm'] as num?)?.toDouble() ?? height;
    weight = (profile['weight_kg'] as num?)?.toDouble() ?? weight;
  }
  return (heightCm: height, weightKg: weight);
}
