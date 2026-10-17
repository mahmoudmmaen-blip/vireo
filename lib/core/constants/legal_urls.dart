import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vireo/core/config/app_config.dart';

/// Centralized legal pages URLs and helper launcher.
abstract final class LegalUrls {
  static String get baseUrl => AppConfig.legalBaseUrl;

  static String termsUrl(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode.startsWith('ar');
    return isAr ? '$baseUrl/terms-ar.html' : '$baseUrl/terms-en.html';
  }

  static String privacyUrl(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode.startsWith('ar');
    return isAr ? '$baseUrl/privacy-ar.html' : '$baseUrl/privacy-en.html';
  }

  static String deleteAccountUrl() => '$baseUrl/delete-account.html';

  static String medicalDisclaimerUrl(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode.startsWith('ar');
    return isAr
        ? '$baseUrl/medical_disclaimer_ar.html'
        : '$baseUrl/medical_disclaimer_en.html';
  }

  static Future<void> openTerms(BuildContext context) =>
      open(termsUrl(context));
  static Future<void> openPrivacy(BuildContext context) =>
      open(privacyUrl(context));
  static Future<void> openDeleteAccountPage() => open(deleteAccountUrl());
  static Future<void> openMedicalDisclaimer(BuildContext context) =>
      open(medicalDisclaimerUrl(context));

  static Future<void> open(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }
}
