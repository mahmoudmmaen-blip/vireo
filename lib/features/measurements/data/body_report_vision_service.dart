import 'dart:convert';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:vireo/core/boot/boot_log.dart';
import 'package:vireo/core/config/app_config.dart';
import 'package:vireo/core/services/supabase_service.dart';
import 'package:vireo/features/ai_nutrition/utils/image_compressor.dart';
import 'package:vireo/features/measurements/domain/body_composition_report.dart';

class BodyReportVisionException implements Exception {
  const BodyReportVisionException(this.code);
  final String code;
  @override
  String toString() => code;
}

abstract final class BodyReportVisionService {
  static Future<BodyCompositionReport> analyzeBytes(
    Uint8List imageBytes, {
    String language = 'ar',
  }) async {
    return analyzeMultiple([imageBytes], language: language);
  }

  static Future<BodyCompositionReport> analyzeMultiple(
    List<Uint8List> imagesBytes, {
    String language = 'ar',
  }) async {
    if (!SupabaseService.isInitialized) {
      throw const BodyReportVisionException('OFFLINE');
    }
    if (imagesBytes.isEmpty) {
      throw const BodyReportVisionException('EMPTY_IMAGES');
    }
    try {
      final compressedImages = <String>[];
      for (final raw in imagesBytes.take(3)) {
        final compressed = await MealImageCompressor.compress(raw);
        compressedImages.add(base64Encode(compressed));
      }

      final response = await SupabaseService.client.functions.invoke(
        AppConfig.analyzeMealFunctionName,
        body: {
          'mode': 'body_report',
          'images': compressedImages,
          'image_base64': compressedImages.first,
          'mime_type': 'image/jpeg',
          'language': language,
        },
      );
      final data = response.data;
      final error = data is Map ? data['error']?.toString() : null;
      BootLog.step('analyze-body-report status=${response.status} error=$error');

      if (response.status == 429 || error == 'DAILY_LIMIT') {
        throw const BodyReportVisionException('DAILY_LIMIT');
      }
      if (response.status == 422 || error == 'UNREADABLE') {
        throw const BodyReportVisionException('UNREADABLE');
      }
      if (response.status >= 400) {
        throw BodyReportVisionException(error ?? 'API_ERROR');
      }

      Object? payload = data;
      if (payload is String) {
        try {
          payload = jsonDecode(payload);
        } catch (_) {}
      }
      final report = BodyCompositionParser.parse(payload);
      if (report == null) {
        throw const BodyReportVisionException('UNREADABLE');
      }
      return report;
    } on FunctionException catch (e) {
      BootLog.warn('analyze-body-report FunctionException ${e.status}', e.details);
      if (e.status == 429) throw const BodyReportVisionException('DAILY_LIMIT');
      if (e.status == 422) throw const BodyReportVisionException('UNREADABLE');
      throw BodyReportVisionException(e.details?.toString() ?? 'API_ERROR');
    } on BodyReportVisionException {
      rethrow;
    } catch (e) {
      BootLog.warn('analyze-body-report unexpected', e);
      throw BodyReportVisionException(e.toString());
    }
  }
}
