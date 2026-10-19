import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vireo/core/theme/vireo_colors.dart';
import 'package:vireo/data/models/app_auth_state.dart';
import 'package:vireo/features/auth/providers/auth_provider.dart';
import 'package:vireo/features/social/domain/social_models.dart';
import 'package:vireo/features/social/providers/social_provider.dart';
import 'package:vireo/core/theme/vireo_bridge.dart';

class SocialHubScreen extends ConsumerStatefulWidget {
  const SocialHubScreen({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const SocialHubScreen()),
    );
  }

  @override
  ConsumerState<SocialHubScreen> createState() => _SocialHubScreenState();
}

class _SocialHubScreenState extends ConsumerState<SocialHubScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final locale = Localizations.localeOf(context).languageCode;
    final isArabic = locale.startsWith('ar');

    // Trigger background sync of today's stats
    ref.watch(syncDailyStatsProvider);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text(isArabic ? 'المجتمع والمنافسات' : 'Community & Challenges'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: isArabic ? 'الأصدقاء' : 'Friends'),
            Tab(text: isArabic ? 'التحديات' : 'Challenges'),
            Tab(text: isArabic ? 'مجموعتي العائلية' : 'Family Group'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _FriendsTab(isArabic: isArabic),
          _ChallengesTab(isArabic: isArabic, isFamilyMode: false),
          _ChallengesTab(isArabic: isArabic, isFamilyMode: true),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// 1. FRIENDS TAB
// ──────────────────────────────────────────────

class _FriendsTab extends ConsumerWidget {
  const _FriendsTab({required this.isArabic});

  final bool isArabic;

  void _showAddFriendDialog(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authProvider).valueOrNull;
    if (auth == null || !auth.hasAccountAccess) {
      _showMustSaveProgressDialog(context, isArabic);
      return;
    }

    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isArabic ? 'إضافة صديق' : 'Add Friend'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isArabic
                  ? 'أدخل رمز دعوة الصديق أو معرّف حسابه:'
                  : "Enter your friend's invite code or User ID:",
              style: const TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: isArabic ? 'رمز الصديق...' : 'Friend code...',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final code = controller.text.trim();
              if (code.isNotEmpty) {
                final currentUserId = auth.user?.id ?? '';
                final repo = ref.read(socialRepositoryProvider);
                final ok = await repo.addFriendByCode(
                  currentUserId: currentUserId,
                  friendUserId: code,
                );
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  ref.invalidate(friendsListProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        ok
                            ? (isArabic ? 'تمت إضافة الصديق بنجاح!' : 'Friend added!')
                            : (isArabic ? 'تعذر العثور على هذا الرمز' : 'Could not add friend'),
                      ),
                    ),
                  );
                }
              }
            },
            child: Text(isArabic ? 'إضافة' : 'Add'),
          ),
        ],
      ),
    );
  }

  void _shareMyInviteLink(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authProvider).valueOrNull;
    if (auth == null || !auth.hasAccountAccess) {
      _showMustSaveProgressDialog(context, isArabic);
      return;
    }

    final myUserId = auth.user?.id ?? '';
    final code = myUserId.length > 8 ? myUserId.substring(0, 8).toUpperCase() : myUserId;
    final inviteLink = 'https://vireo.app/join?friend=$code';
    final shareText = isArabic
        ? 'انضم إليّ على تطبيق Vireo لننافس بعضنا في النشاط والخطوات! 🌱\nالرابط: $inviteLink\nالرمز: $code'
        : 'Join me on Vireo to track our steps and stay active together! 🌱\nLink: $inviteLink\nCode: $code';

    Clipboard.setData(ClipboardData(text: shareText));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isArabic
              ? 'تم نسخ رابط الدعوة الخاص بك! جاهز للمشاركة على واتساب.'
              : 'Invite link copied to clipboard! Share it with friends.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.vireoColors;
    final friendsAsync = ref.watch(friendsListProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Privacy Banner
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colors.surfaceRaised,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.line),
          ),
          child: Row(
            children: [
              const Icon(Icons.shield_outlined, color: VBridge.cFF22C55E, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isArabic
                      ? 'الخصوصية أولاً: تشارك مع أصدقائك فقط الخطوات ومرات التسجيل. بيانات وجباتك ووزنك وصحتك لا يراها أحد سواك أبداً.'
                      : 'Privacy first: You only share steps, streak & logged-today status. Your food, weight, and health data are completely private.',
                  style: TextStyle(color: colors.textMute, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Action Buttons: Share invite link, Add friend
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _shareMyInviteLink(context, ref),
                icon: const Icon(Icons.share_outlined, size: 18),
                label: Text(isArabic ? 'دعوة صديق' : 'Invite Friend'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => _showAddFriendDialog(context, ref),
                icon: const Icon(Icons.person_add_outlined, size: 18),
                label: Text(isArabic ? 'إضافة برمز' : 'Add by Code'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        Text(
          isArabic ? 'قائمة الأصدقاء' : 'My Friends',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),

        friendsAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (_, __) => Center(
            child: Text(isArabic ? 'تعذر تحميل الأصدقاء' : 'Failed to load friends'),
          ),
          data: (friends) {
            if (friends.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(Icons.people_outline, size: 48, color: colors.textMute),
                      const SizedBox(height: 12),
                      Text(
                        isArabic
                            ? 'لم تضف أصدقاء بعد. شارك رابطك وابدأ المنافسة!'
                            : 'No friends yet. Share your invite code to start!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colors.textMute),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: friends.map((f) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: colors.surfaceRaised,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: colors.ember.withValues(alpha: 0.2),
                      child: Text(
                        f.displayName.isNotEmpty ? f.displayName[0].toUpperCase() : 'F',
                        style: TextStyle(color: colors.ember, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(f.displayName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Row(
                      children: [
                        Text('👟 ${f.todaySteps} ${isArabic ? "خطوة" : "steps"}'),
                        const SizedBox(width: 12),
                        Text('🔥 ${f.currentStreak}d'),
                        if (f.hasLoggedToday) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.check_circle, size: 14, color: VBridge.cFF22C55E),
                        ],
                      ],
                    ),
                    trailing: PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: colors.textMute),
                      onSelected: (action) async {
                        if (action == 'report') {
                          _showReportUserDialog(context, ref, f, isArabic);
                        } else if (action == 'block') {
                          final auth = ref.read(authProvider).valueOrNull;
                          final currentUserId = auth?.user?.id ?? '';
                          await ref.read(socialRepositoryProvider).blockUser(
                                currentUserId: currentUserId,
                                targetUserId: f.userId,
                              );
                          ref.invalidate(friendsListProvider);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isArabic ? 'تم حظر المستخدم.' : 'User has been blocked.',
                                ),
                              ),
                            );
                          }
                        }
                      },
                      itemBuilder: (ctx) => [
                        PopupMenuItem(
                          value: 'report',
                          child: Text(isArabic ? 'إبلاغ عن المستخدم' : 'Report user'),
                        ),
                        PopupMenuItem(
                          value: 'block',
                          child: Text(
                            isArabic ? 'حظر الصديق' : 'Block user',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// 2. CHALLENGES & FAMILY TAB
// ──────────────────────────────────────────────

class _ChallengesTab extends ConsumerWidget {
  const _ChallengesTab({
    required this.isArabic,
    required this.isFamilyMode,
  });

  final bool isArabic;
  final bool isFamilyMode;

  void _showCreateChallengeDialog(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authProvider).valueOrNull;
    if (auth == null || !auth.hasAccountAccess) {
      _showMustSaveProgressDialog(context, isArabic);
      return;
    }

    final titleController = TextEditingController(
      text: isFamilyMode
          ? (isArabic ? 'تحدي خطوات العائلة' : 'Family Steps Challenge')
          : (isArabic ? 'تحدي خطوات الأسبوع' : 'Weekly Steps Challenge'),
    );

    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          isFamilyMode
              ? (isArabic ? 'إنشاء مجموعة عائلية (حتى 6 أفراد)' : 'Create Family Group (Up to 6)')
              : (isArabic ? 'إنشاء تحدي جديد' : 'Create New Challenge'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: isArabic ? 'عنوان التحدي' : 'Challenge title',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final title = titleController.text.trim();
              if (title.isNotEmpty) {
                final currentUserId = auth.user?.id ?? '';
                final repo = ref.read(socialRepositoryProvider);
                await repo.createChallenge(
                  ownerId: currentUserId,
                  title: title,
                  type: ChallengeType.weeklySteps,
                  isFamily: isFamilyMode,
                );
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  ref.invalidate(myChallengesProvider);
                }
              }
            },
            child: Text(isArabic ? 'إنشاء' : 'Create'),
          ),
        ],
      ),
    );
  }

  void _showJoinDialog(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authProvider).valueOrNull;
    if (auth == null || !auth.hasAccountAccess) {
      _showMustSaveProgressDialog(context, isArabic);
      return;
    }

    final codeController = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isArabic ? 'الانضمام برمز التحدي' : 'Join by Challenge Code'),
        content: TextField(
          controller: codeController,
          decoration: InputDecoration(
            hintText: isArabic ? 'أدخل الرمز (مثال: VIREO77)' : 'Enter code (e.g. VIREO77)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              final code = codeController.text.trim();
              if (code.isNotEmpty) {
                final currentUserId = auth.user?.id ?? '';
                final repo = ref.read(socialRepositoryProvider);
                final ok = await repo.joinChallengeByCode(
                  userId: currentUserId,
                  inviteCode: code,
                );
                if (ctx.mounted) {
                  Navigator.pop(ctx);
                  ref.invalidate(myChallengesProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        ok
                            ? (isArabic ? 'تم الانضمام للتحدي!' : 'Joined challenge!')
                            : (isArabic ? 'رمز غير صالح أو اكتمل العدد' : 'Invalid code or full'),
                      ),
                    ),
                  );
                }
              }
            },
            child: Text(isArabic ? 'انضمام' : 'Join'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.vireoColors;
    final challengesAsync = ref.watch(myChallengesProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.surfaceRaised,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colors.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isFamilyMode
                    ? (isArabic ? 'مجموعات العائلة الرياضية' : 'Family Steps Groups')
                    : (isArabic ? 'تحديات الخطوات الأسبوعية' : 'Weekly Steps Challenges'),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                isFamilyMode
                    ? (isArabic
                        ? 'اجمع حتى 6 أفراد من أسرتك في مجموعة واحدة وشاركوا إجمالي الخطوات الأسبوعية معاً.'
                        : 'Team up with up to 6 family members and pool your weekly steps together.')
                    : (isArabic
                        ? 'تنافس في لوحة المتصدرين الأسبوعية مع رتب وتحديثات يومية.'
                        : 'Compete on weekly leaderboards with ranks and daily updates.'),
                style: TextStyle(color: colors.textMute, fontSize: 12),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => _showCreateChallengeDialog(context, ref),
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(isArabic ? 'إنشاء جديد' : 'Create'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showJoinDialog(context, ref),
                      icon: const Icon(Icons.login, size: 18),
                      label: Text(isArabic ? 'انضمام برمز' : 'Join Code'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        challengesAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (_, __) => Center(
            child: Text(isArabic ? 'تعذر تحميل التحديات' : 'Failed to load challenges'),
          ),
          data: (all) {
            final filtered = all.where((c) => c.isFamily == isFamilyMode).toList();
            if (filtered.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(
                        isFamilyMode ? Icons.family_restroom : Icons.emoji_events_outlined,
                        size: 48,
                        color: colors.textMute,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isFamilyMode
                            ? (isArabic
                                ? 'لا توجد مجموعة عائلية نشطة. أنشئ مجموعتك الآن!'
                                : 'No active family group. Create one!')
                            : (isArabic
                                ? 'لا توجد تحديات حالية. أنشئ تحدياً أو انضم برمز.'
                                : 'No challenges yet. Create or join one with code.'),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colors.textMute),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: filtered.map((c) => _ChallengeCard(c: c, isArabic: isArabic)).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _ChallengeCard extends ConsumerWidget {
  const _ChallengeCard({required this.c, required this.isArabic});

  final ChallengeModel c;
  final bool isArabic;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.vireoColors;
    final totalSteps = c.members.fold<int>(0, (sum, m) => sum + m.score);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceRaised,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  c.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.ember.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${isArabic ? "الرمز:" : "Code:"} ${c.inviteCode}',
                  style: TextStyle(
                    color: colors.ember,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.timer_outlined, size: 14, color: colors.textMute),
              const SizedBox(width: 4),
              Text(
                c.isEnded
                    ? (isArabic ? 'انتهى التحدي 🏁' : 'Challenge Ended 🏁')
                    : '${c.daysLeft} ${isArabic ? "أيام متبقية" : "days left"}',
                style: TextStyle(color: colors.textMute, fontSize: 12),
              ),
              const Spacer(),
              if (c.isFamily)
                Text(
                  '${isArabic ? "إجمالي العائلة:" : "Family Total:"} $totalSteps 👟',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
            ],
          ),
          const Divider(height: 24),

          // Leaderboard
          Text(
            isArabic ? 'لوحة المتصدرين' : 'Leaderboard',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),

          ...c.members.map((m) {
            final isWinner = m.rank == 1;
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: isWinner
                    ? colors.ember.withValues(alpha: 0.1)
                    : colors.surface.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Text(
                    '#${m.rank}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isWinner ? colors.ember : colors.textMute,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    m.displayName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text(
                    '${m.score} 👟',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: () async {
                final auth = ref.read(authProvider).valueOrNull;
                final userId = auth?.user?.id ?? '';
                await ref.read(socialRepositoryProvider).leaveChallenge(
                      userId: userId,
                      challengeId: c.id,
                    );
                ref.invalidate(myChallengesProvider);
              },
              child: Text(
                isArabic ? 'مغادرة التحدي' : 'Leave challenge',
                style: TextStyle(color: colors.textMute, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// DIALOG HELPERS
// ──────────────────────────────────────────────

void _showMustSaveProgressDialog(BuildContext context, bool isArabic) {
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(isArabic ? 'احفظ تقدمك أولاً' : 'Save Your Progress First'),
      content: Text(
        isArabic
            ? 'الميزات الاجتماعية ومنافسة الأصدقاء تتطلب حساباً لحفظ بياناتك ومشاركتها بأمان.'
            : 'Social features require an account so your steps and streaks can be synced safely.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(isArabic ? 'حسناً' : 'OK'),
        ),
      ],
    ),
  );
}

void _showReportUserDialog(
  BuildContext context,
  WidgetRef ref,
  FriendSummary friend,
  bool isArabic,
) {
  final reasonController = TextEditingController();
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(isArabic ? 'إبلاغ وحظر المستخدم' : 'Report & Block User'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic
                ? 'يرجى كتابة سبب الإبلاغ عن ${friend.displayName}:'
                : 'Please state the reason for reporting ${friend.displayName}:',
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: reasonController,
            decoration: InputDecoration(
              hintText: isArabic ? 'السلوك غير لائق...' : 'Inappropriate conduct...',
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(isArabic ? 'إلغاء' : 'Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            final auth = ref.read(authProvider).valueOrNull;
            final currentUserId = auth?.user?.id ?? '';
            final reason = reasonController.text.trim();
            await ref.read(socialRepositoryProvider).reportUser(
                  reporterId: currentUserId,
                  reportedUserId: friend.userId,
                  reason: reason.isNotEmpty ? reason : 'Inappropriate conduct',
                );
            ref.invalidate(friendsListProvider);
            if (ctx.mounted) {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isArabic
                        ? 'تم إرسال البلاغ وحظر المستخدم.'
                        : 'Report submitted and user blocked.',
                  ),
                ),
              );
            }
          },
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          child: Text(isArabic ? 'إبلاغ وحظر' : 'Report & Block'),
        ),
      ],
    ),
  );
}
