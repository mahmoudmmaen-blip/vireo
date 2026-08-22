import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/l10n/generated/app_localizations.dart';
import 'package:vireo/core/widgets/language_selector.dart';
import 'package:vireo/core/widgets/feature_scaffold.dart';
import 'package:vireo/features/home/widgets/home_dashboard_body.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return FeatureScaffold(
      title: l10n.homeTitle,
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 8),
          child: LanguageSelector(compact: true),
        ),
      ],
      body: const HomeDashboardBody(),
    );
  }
}
