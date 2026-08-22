import 'package:vireo/core/config/app_config.dart';
import 'package:vireo/core/services/supabase_service.dart';

/// Client for the fridge vision Edge Function (Section 4 prompt).
class FridgeScanRepository {
  const FridgeScanRepository();

  static const basicMonthlyLimit = 5;

  Future<FridgeScanResult> scanImage({
    required String imageBase64,
    String mimeType = 'image/jpeg',
    String? imageUrl,
  }) async {
    if (!SupabaseService.isInitialized) {
      throw const FridgeScanException('Supabase is not configured.');
    }

    try {
      final response = await SupabaseService.client.functions.invoke(
        AppConfig.scanFridgeVisionFunctionName,
        body: {
          if (imageUrl != null) 'image_url': imageUrl,
          if (imageUrl == null) 'image_base64': imageBase64,
          'mime_type': mimeType,
        },
      );

      if (response.status >= 400) {
        final data = response.data;
        final code = data is Map ? data['error']?.toString() : null;
        if (code == 'SCAN_LIMIT_REACHED') {
          throw const FridgeScanLimitException();
        }
        throw FridgeScanException(code ?? 'Fridge scan failed.');
      }

      final data = Map<String, dynamic>.from(response.data as Map);
      return FridgeScanResult(
        scanId: data['scan_id'] as String,
        ingredients: List<String>.from(data['ingredients'] as List? ?? []),
        remainingScans: data['remaining_scans'] as int?,
      );
    } catch (e) {
      if (e is FridgeScanException) rethrow;
      throw FridgeScanException(e.toString());
    }
  }

  Future<void> confirmIngredients({
    required String scanId,
    required List<String> confirmedItems,
  }) async {
    if (!SupabaseService.isInitialized) return;
    try {
      await SupabaseService.client
          .from('fridge_scans')
          .update({'confirmed_items': confirmedItems})
          .eq('id', scanId);
    } catch (_) {
      rethrow;
    }
  }
}

class FridgeScanResult {
  const FridgeScanResult({
    required this.scanId,
    required this.ingredients,
    this.remainingScans,
  });

  final String scanId;
  final List<String> ingredients;
  final int? remainingScans;
}

class FridgeScanException implements Exception {
  const FridgeScanException(this.message);
  final String message;

  @override
  String toString() => message;
}

class FridgeScanLimitException extends FridgeScanException {
  const FridgeScanLimitException()
      : super('Monthly fridge scan limit reached.');
}
