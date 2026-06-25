import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/router/app_router.dart';
import '../../../core/tokens/design_tokens.dart';
import '../../../shared/providers/user_provider.dart';
import '../../../shared/widgets/app_icon.dart';
import '../../../shared/widgets/glossy_icon_badge.dart';
import '../../../shared/widgets/tt_card.dart';
import '../providers/dashboard_provider.dart';

// Enables mouse/trackpad drag on macOS for horizontal scroll
class _AllDeviceScroll extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(dashboardProvider);
    final isDark = context.isDark;
    final userName = ref.watch(userNameProvider);

    return Scaffold(
      backgroundColor: isDark ? Clr.darkBg : Clr.warmBg,
      body: RefreshIndicator(
        color: Clr.accent,
        backgroundColor: isDark ? Clr.darkCard : Colors.white,
        onRefresh: () {
          ref.invalidate(allActivityProvider);
          return ref.refresh(dashboardProvider.future);
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _Header(userName: userName, isDark: isDark),
            async.when(
              data: (d) => _Body(data: d, isDark: isDark),
              loading: () => const SliverFillRemaining(
                hasScrollBody: false,
                child: _Skeleton(),
              ),
              error: (_, __) => SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    'Could not load data',
                    style: Tx.body.copyWith(color: Clr.textMid),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final String userName;
  final bool isDark;
  const _Header({required this.userName, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('EEEE, d MMMM').format(DateTime.now());
    final first = userName.trim().isEmpty
        ? null
        : userName.trim().split(' ').first;
    final initials = userName.trim().isEmpty
        ? 'ME'
        : userName.trim().split(' ').map((w) => w[0]).take(2).join().toUpperCase();

    return SliverAppBar(
      pinned: true,
      backgroundColor: isDark ? Clr.darkBg : Clr.warmBg,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      expandedHeight: 0,
      toolbarHeight: 62,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spc.screen),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Clr.accent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: Clr.accent.withValues(alpha: 0.28), width: 1),
                ),
                child: Center(
                  child: Text(
                    initials,
                    style: const TextStyle(
                      color: Clr.accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      first == null ? 'Overview' : 'Hi, $first 👋',
                      overflow: TextOverflow.ellipsis,
                      style: Tx.h3.copyWith(
                        color: isDark ? Colors.white : Clr.textDark,
                      ),
                    ),
                    Text(
                      date,
                      overflow: TextOverflow.ellipsis,
                      style: Tx.caption.copyWith(color: Clr.textMid),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Notification bell
              _IconBtn(
                icon: CupertinoIcons.bell,
                isDark: isDark,
                onTap: () {},
              ),
              const SizedBox(width: 6),
              // Settings
              _IconBtn(
                icon: CupertinoIcons.slider_horizontal_3,
                isDark: isDark,
                onTap: () => context.push(AppRoutes.settings),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;
  const _IconBtn(
      {required this.icon, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.07)
              : Colors.black.withValues(alpha: 0.06),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 18,
          color: isDark
              ? Colors.white.withValues(alpha: 0.7)
              : Clr.textDark.withValues(alpha: 0.65),
        ),
      ),
    );
  }
}

// ── Body ──────────────────────────────────────────────────────────────────────

class _Body extends StatelessWidget {
  final DashboardSummary data;
  final bool isDark;
  const _Body({required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return SliverPadding(
      padding: EdgeInsets.only(bottom: bottomPad + 100),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          // Daily summary
          Padding(
            padding: const EdgeInsets.fromLTRB(Spc.screen, 12, Spc.screen, 0),
            child: _HeroBalance(data: data, isDark: isDark),
          ),
          const SizedBox(height: Spc.section),

          // Quick actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spc.screen),
            child: _QuickActions(isDark: isDark),
          ),
          const SizedBox(height: Spc.section),

          // Today's activity
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spc.screen),
            child: _TodayActivitySection(isDark: isDark),
          ),
          const SizedBox(height: 12),

          // Asset category strip
          _AssetStrip(data: data, isDark: isDark),
          const SizedBox(height: 12),

          // Financial health
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spc.screen),
            child: _HealthCard(data: data, isDark: isDark),
          ),
        ]),
      ),
    );
  }
}

// ── Daily Summary Card ────────────────────────────────────────────────────────

class _HeroBalance extends StatelessWidget {
  final DashboardSummary data;
  final bool isDark;
  const _HeroBalance({required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final totalNet = data.totalIncome - data.totalExpense;
    final isPositive = totalNet >= 0;
    final date = DateFormat('EEEE, d MMM').format(DateTime.now());

    final onCardMid  = Colors.white.withValues(alpha: 0.55);
    final onCardSep  = Colors.white.withValues(alpha: 0.15);
    const incomeClr  = Color(0xFF4ADE80); // soft green on dark bg
    const expenseClr = Color(0xFFF87171); // soft red on dark bg

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Rad.xl),
        gradient: const LinearGradient(
                colors: [Color(0xFF020E09), Color(0xFF004030)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        boxShadow: [
          BoxShadow(
            color: Clr.accent.withValues(alpha: 0.22),
            blurRadius: 28,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Rad.xl),
        child: Padding(
          padding: const EdgeInsets.all(Spc.card),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('TOTAL',
                      style: Tx.micro.copyWith(
                          color: onCardMid)),
                  const Spacer(),
                  Text(date,
                      style: Tx.caption.copyWith(color: onCardMid)),
                ],
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                  color: incomeClr, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 6),
                            Text('Income',
                                style: Tx.caption.copyWith(color: onCardMid)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: data.totalIncome),
                          duration: const Duration(milliseconds: 900),
                          curve: Curves.easeOutCubic,
                          builder: (_, v, __) => FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(v.taka,
                                style: Tx.h2.copyWith(
                                    color: incomeClr, fontSize: 22)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 0.5,
                    height: 48,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    color: onCardSep,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                  color: expenseClr, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 6),
                            Text('Expenses',
                                style: Tx.caption.copyWith(color: onCardMid)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: data.totalExpense),
                          duration: const Duration(milliseconds: 900),
                          curve: Curves.easeOutCubic,
                          builder: (_, v, __) => FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(v.taka,
                                style: Tx.h2.copyWith(
                                    color: expenseClr, fontSize: 22)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Divider(height: 1, thickness: 0.5, color: onCardSep),
              ),
              Row(
                children: [
                  Text('Net Balance',
                      style: Tx.bodyMed.copyWith(color: onCardMid)),
                  Expanded(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: totalNet.abs()),
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.easeOutCubic,
                      builder: (_, v, __) => Text(
                        v.taka,
                        textAlign: TextAlign.right,
                        style: Tx.h2.copyWith(
                          color: isPositive ? incomeClr : expenseClr,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, curve: Curves.easeOut)
        .slideY(begin: 0.08, end: 0, curve: Curves.easeOut);
  }
}

// ── Quick Actions ─────────────────────────────────────────────────────────────

class _QuickActions extends StatelessWidget {
  final bool isDark;
  const _QuickActions({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final actions = [
      (AppIcons.expenses, 'Expense', AppRoutes.addExpense, Clr.expense),
      (AppIcons.income,   'Income',  AppRoutes.addIncome,  Clr.income),
      (AppIcons.loan,     'Lend',    '${AppRoutes.addLoan}?type=lent', Clr.warning),
      (AppIcons.budget,   'Budget',  AppRoutes.addBudget,  Clr.info),
    ];

    return Row(
      children: actions.map((a) {
        final (icon, label, route, color) = a;
        return Expanded(
          child: _PressableTile(
            onTap: () {
              HapticFeedback.selectionClick();
              context.push(route);
            },
            child: Column(
              children: [
                GlossyIconBadge(icon: icon, color: color, size: 52, iconSize: 23),
                const SizedBox(height: 7),
                Text(
                  label,
                  style: Tx.caption.copyWith(
                    color: Clr.textMid,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

String _activityTimeLabel(DateTime time) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final yesterday = today.subtract(const Duration(days: 1));
  final itemDay = DateTime(time.year, time.month, time.day);
  final timeStr = DateFormat('h:mm a').format(time);

  if (itemDay.year == today.year &&
      itemDay.month == today.month &&
      itemDay.day == today.day) {
    return timeStr;
  }
  if (itemDay.year == yesterday.year &&
      itemDay.month == yesterday.month &&
      itemDay.day == yesterday.day) {
    return 'Yesterday · $timeStr';
  }
  if (today.difference(itemDay).inDays < 7) {
    return '${DateFormat('EEE').format(time)} · $timeStr';
  }
  return '${DateFormat('MMM d').format(time)} · $timeStr';
}

// ── Today Activity Section ────────────────────────────────────────────────────

class _TodayActivitySection extends ConsumerWidget {
  final bool isDark;
  const _TodayActivitySection({required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityAsync = ref.watch(allActivityProvider);
    final onSurface = isDark ? Colors.white : Clr.textDark;
    final sep = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : Colors.black.withValues(alpha: 0.06);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('All Activities',
                style: Tx.h3.copyWith(color: onSurface)),
            GestureDetector(
              onTap: () => context.push(AppRoutes.expenses),
              child: Text('See all',
                  style: Tx.caption.copyWith(
                      color: Clr.accent, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        activityAsync.when(
          data: (items) {
            if (items.isEmpty) {
              return TTCard(
                radius: Rad.xl,
                padding: const EdgeInsets.symmetric(
                    vertical: 28, horizontal: Spc.card),
                child: Center(
                  child: Text('No transactions yet',
                      style: Tx.body.copyWith(color: Clr.textMid)),
                ),
              );
            }
            return TTCard(
              radius: Rad.xl,
              padding: EdgeInsets.zero,
              child: Column(
                children: items.asMap().entries.map((e) {
                  final i = e.key;
                  final item = e.value;
                  final isIncome = item.type == 'income';
                  final itemColor = isIncome ? Clr.income : Clr.expense;
                  final iconData = isIncome
                      ? AppIcons.income
                      : AppIcons.categoryIcon(item.label);
                  final iconColor = isIncome
                      ? Clr.income
                      : AppIcons.categoryColor(item.label);
                  final timeLabel = _activityTimeLabel(item.time);

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Spc.card, vertical: 10),
                        child: Row(
                          children: [
                            GlossyIconBadge(
                              icon: iconData,
                              color: iconColor,
                              size: 40,
                              iconSize: 18,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.label,
                                      style: Tx.bodyMed.copyWith(
                                          color: onSurface),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 2),
                                  Text(timeLabel,
                                      style: Tx.caption
                                          .copyWith(color: Clr.textMid)),
                                ],
                              ),
                            ),
                            Text(
                              '${isIncome ? '+' : '-'}${item.amount.taka}',
                              style: Tx.bodyMed.copyWith(
                                  color: itemColor,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      if (i < items.length - 1)
                        Divider(
                            height: 1, thickness: 0.5, color: sep,
                            indent: Spc.card + 36 + 12,
                            endIndent: Spc.card),
                    ],
                  )
                      .animate()
                      .fadeIn(delay: (i * 55).ms, duration: 280.ms)
                      .slideX(
                          begin: -0.04,
                          end: 0,
                          delay: (i * 55).ms,
                          duration: 280.ms,
                          curve: Curves.easeOut);
                }).toList(),
              ),
            );
          },
          loading: () => TTCard(
            radius: Rad.xl,
            padding: const EdgeInsets.all(Spc.card),
            child: const Center(child: CupertinoActivityIndicator(radius: 12)),
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }
}

// ── Asset Strip ───────────────────────────────────────────────────────────────

class _AssetStrip extends StatelessWidget {
  final DashboardSummary data;
  final bool isDark;
  const _AssetStrip({required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final pills = [
      (AppIcons.cash,        'Cash',   data.totalCash,           AppRoutes.cash,           const Color(0xFF30D158)), // systemGreen
      (AppIcons.bank,        'Banks',  data.totalBank,           AppRoutes.banks,           const Color(0xFF0A84FF)), // systemBlue
      (AppIcons.dps,         'DPS',    data.totalDps,            AppRoutes.dps,             const Color(0xFFFF9F0A)), // systemOrange
      (AppIcons.fdr,         'FDR',    data.totalFdr,            AppRoutes.fdr,             const Color(0xFFBF5AF2)), // systemPurple
      (AppIcons.sanchayapatra,'Bonds', data.totalSanchayapatra,  AppRoutes.sanchayapatra,   const Color(0xFF5AC8FA)), // systemCyan
      (AppIcons.investments, 'Invest', data.totalInvestments,    AppRoutes.investments,     const Color(0xFF5E5CE6)), // systemIndigo
    ];

    final sw = MediaQuery.of(context).size.width;
    const hPad = Spc.screen;
    const gap = 10.0;
    const minW = 104.0;
    final fitW = (sw - hPad * 2 - gap * (pills.length - 1)) / pills.length;
    final pillW = fitW >= minW ? fitW : minW;

    return ScrollConfiguration(
      behavior: _AllDeviceScroll(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: hPad),
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: pills.asMap().entries.map((e) {
            final i = e.key;
            final (icon, label, amount, route, color) = e.value;
            return Padding(
              padding: EdgeInsets.only(right: i < pills.length - 1 ? gap : 0),
              child: _AssetPill(
                icon: icon,
                label: label,
                amount: amount,
                route: route,
                color: color,
                isDark: isDark,
                width: pillW,
                delay: (i * 40).ms,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _AssetPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final double amount;
  final String route;
  final Color color;
  final bool isDark;
  final double width;
  final Duration delay;
  const _AssetPill({
    required this.icon,
    required this.label,
    required this.amount,
    required this.route,
    required this.color,
    required this.isDark,
    required this.width,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return _PressableTile(
      onTap: () {
        HapticFeedback.selectionClick();
        context.push(route);
      },
      child: Container(
        width: width,
        height: 96,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        decoration: BoxDecoration(
          color: isDark ? Clr.darkCard : Clr.warmCard,
          borderRadius: BorderRadius.circular(Rad.lg),
          border: isDark
              ? Border.all(
                  color: Colors.white.withValues(alpha: 0.07), width: 0.5)
              : null,
          boxShadow: Shd.card(isDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? 0.18 : 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: AppIcon(icon, color: color, size: 15),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: Tx.micro
                        .copyWith(color: Clr.textMid)),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    amount.takaCompact,
                    style: Tx.h3.copyWith(
                      color: isDark ? Colors.white : Clr.textDark,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(delay: delay, duration: 320.ms)
          .slideX(
              begin: 0.07,
              end: 0,
              delay: delay,
              duration: 320.ms,
              curve: Curves.easeOut),
    );
  }
}

// ── Financial Health ──────────────────────────────────────────────────────────

class _HealthCard extends StatelessWidget {
  final DashboardSummary data;
  final bool isDark;
  const _HealthCard({required this.data, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final score = data.healthScore.clamp(0.0, 100.0);
    final color = score >= 70
        ? Clr.accent
        : score >= 40
            ? Clr.warning
            : Clr.expense;
    final label = score >= 70
        ? 'Great shape — keep it up'
        : score >= 40
            ? 'Room to improve'
            : 'Needs attention';

    return TTCard(
      radius: Rad.xl,
      padding: const EdgeInsets.all(Spc.card),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('FINANCIAL HEALTH',
                  style: Tx.micro
                      .copyWith(color: Clr.textMid)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: score),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOutCubic,
                    builder: (_, v, __) => Text(
                      v.round().toString(),
                      style: Tx.h1.copyWith(color: color, fontSize: 22),
                    ),
                  ),
                  Text('/100',
                      style: Tx.body.copyWith(
                          color: Clr.textMid, fontSize: 13)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(Rad.full),
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: 5,
              backgroundColor: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.07),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              borderRadius: BorderRadius.circular(Rad.full),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(label,
                style: Tx.caption.copyWith(color: Clr.textMid)),
          ),
        ],
      ),
    );
  }
}

// ── Pressable tile with spring-back scale ────────────────────────────────────

class _PressableTile extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _PressableTile({required this.child, required this.onTap});

  @override
  State<_PressableTile> createState() => _PressableTileState();
}

class _PressableTileState extends State<_PressableTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 350),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: Curves.easeIn,
        reverseCurve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

// ── Skeleton ──────────────────────────────────────────────────────────────────

class _Skeleton extends StatelessWidget {
  const _Skeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Spc.screen, 16, Spc.screen, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero card bone
          _Bone(w: double.infinity, h: 160, isDark: isDark, r: Rad.hero),
          const SizedBox(height: Spc.section),
          // Quick actions
          Row(
            children: List.generate(
                4,
                (i) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: i < 3 ? 8 : 0),
                        child: Column(
                          children: [
                            _Bone(w: 52, h: 52, isDark: isDark, r: 26),
                            const SizedBox(height: 6),
                            _Bone(w: 40, h: 10, isDark: isDark, r: 5),
                          ],
                        ),
                      ),
                    )),
          ),
          const SizedBox(height: Spc.section),
          // Asset strip
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              children: List.generate(
                5,
                (i) => Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _Bone(w: 104, h: 78, isDark: isDark, r: Rad.lg),
                ),
              ),
            ),
          ),
          const SizedBox(height: Spc.section),
          _Bone(w: double.infinity, h: 160, isDark: isDark, r: Rad.xl),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _Bone(h: 96, isDark: isDark, r: Rad.xl)),
              const SizedBox(width: 12),
              Expanded(child: _Bone(h: 96, isDark: isDark, r: Rad.xl)),
            ],
          ),
          const SizedBox(height: 12),
          _Bone(w: double.infinity, h: 80, isDark: isDark, r: Rad.xl),
        ],
      ),
    )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(
          delay: 300.ms,
          duration: 1400.ms,
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.05),
        );
  }
}

class _Bone extends StatelessWidget {
  final double? w;
  final double h;
  final bool isDark;
  final double r;
  const _Bone(
      {this.w, required this.h, required this.isDark, required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.07)
            : Colors.black.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(r),
      ),
    );
  }
}
