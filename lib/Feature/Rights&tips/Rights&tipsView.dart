import 'package:admin_qudra/Feature/Rights&tips/viewModel/right_tips_cubit.dart';
import 'package:admin_qudra/Feature/Rights&tips/widgets/AddTipView.dart';
import 'package:admin_qudra/Feature/Rights&tips/widgets/UpdateTipView.dart';
import 'package:admin_qudra/core/Styles/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_qudra/Feature/Rights&tips/viewModel/right_tips_state.dart';
import 'package:admin_qudra/core/Models/tips&rightsModel.dart';

import '../Dashboard/widgets/Drawer.dart';

class RightstipsView extends StatefulWidget {
  const RightstipsView({Key? key}) : super(key: key);

  @override
  State<RightstipsView> createState() => _RightstipsViewState();
}

class _RightstipsViewState extends State<RightstipsView> {
  @override
  void initState() {
    super.initState();

    // This block loads all awareness resources when the admin screen opens.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RightstipsCubit>().loadAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const QudraDrawer(),
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: BlocConsumer<RightstipsCubit, RightstipsState>(
        listener: (context, state) {
          if (state is RightstipsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red[600],
                behavior: SnackBarBehavior.floating,
              ),
            );
          }

          if (state is RightstipsActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green[600],
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => context.read<RightstipsCubit>().loadAll(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // This block shows the main page title and short description.
                    _buildPageIntro(),

                    const SizedBox(height: 20),

                    // This block opens the add awareness resource screen.
                    _buildActionButtons(context),

                    const SizedBox(height: 24),

                    if (state is RightstipsLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 48),
                          child: CircularProgressIndicator(
                            color: Color(0xFF1C1C1E),
                          ),
                        ),
                      )
                    else if (state is RightstipsError)
                      _buildErrorWidget(context, state.message)
                    else if (state is RightstipsLoaded) ...[
                        // This block shows quick counters for each content type.
                        _buildContentSummaryCards(state.tips),

                        const SizedBox(height: 28),

                        // This block renders the resources section header.
                        _buildSectionHeader(
                          icon: Icons.auto_stories_rounded,
                          title: 'Awareness Resources',
                          actionText: '${state.tips.length} total',
                        ),

                        const SizedBox(height: 16),

                        // This block renders the upgraded awareness resources list.
                        _buildTipsList(context, state.tips),
                      ] else
                        const SizedBox.shrink(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // This widget renders the main page intro text.
  Widget _buildPageIntro() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Accessibility Awareness Hub',
          style: TextStyle(
            color: Color(0xFF1C1C1E),
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Manage tips, rights, articles, and video resources shown in the user app.',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  // This widget builds the awareness resources list.
  Widget _buildTipsList(BuildContext context, List<tipsRightsModel> tips) {
    if (tips.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Text(
            'No resources yet. Add the first one!',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    // This block sorts resources by newest first using createdAt.
    final sortedTips = [...tips]
      ..sort(
            (a, b) => b.createdAt.compareTo(a.createdAt),
      );

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sortedTips.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final tip = sortedTips[index];

        return PracticalTipCard(
          tip: tip,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<RightstipsCubit>(),
                  child: UpdateTipView(tip: tip),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // This widget renders an error state with a retry action.
  Widget _buildErrorWidget(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.redAccent,
              size: 36,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.read<RightstipsCubit>().loadAll(),
              child: const Text(
                'Retry',
                style: TextStyle(color: Color(0xFF1C1C1E)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // This widget builds the dashboard-style app bar.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF2F2F7),
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(
            Icons.menu,
            color: Color(0xFF1C1C1E),
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: const Text(
        'Qudra Hub',
        style: TextStyle(
          color: Color(0xFF1C1C1E),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: Color(0xFFE5E5EA),
            radius: 16,
            child: Text(
              'AP',
              style: TextStyle(
                color: Color(0xFF1C1C1E),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // This widget builds the add resource button.
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<RightstipsCubit>(),
                    child: const AddTipView(),
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.add_circle_outline,
              color: AppColors.white,
              size: 20,
            ),
            label: const Text(
              'Add Resource',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: AppColors.primary,
              side: BorderSide(color: Colors.grey.withOpacity(0.3)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // This widget shows counters for the four awareness content types.
  Widget _buildContentSummaryCards(List<tipsRightsModel> tips) {
    final tipCount = tips
        .where((item) => item.contentType == AwarenessContentType.tip)
        .length;
    final rightCount = tips
        .where((item) => item.contentType == AwarenessContentType.right)
        .length;
    final articleCount = tips
        .where((item) => item.contentType == AwarenessContentType.article)
        .length;
    final videoCount = tips
        .where((item) => item.contentType == AwarenessContentType.video)
        .length;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ResourceStatCard(
                label: 'Tips',
                count: tipCount,
                icon: Icons.lightbulb_outline,
                color: const Color(0xFFF59E0B),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ResourceStatCard(
                label: 'Rights',
                count: rightCount,
                icon: Icons.gavel_rounded,
                color: const Color(0xFF3B82F6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ResourceStatCard(
                label: 'Articles',
                count: articleCount,
                icon: Icons.article_outlined,
                color: const Color(0xFF10B981),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ResourceStatCard(
                label: 'Videos',
                count: videoCount,
                icon: Icons.play_circle_outline,
                color: const Color(0xFFEF4444),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // This widget renders a section header row.
  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    String? actionText,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: const Color(0xFF1C1C1E),
          size: 22,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF1C1C1E),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (actionText != null)
          Text(
            actionText,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}

// This widget renders a compact resource counter card.
class _ResourceStatCard extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final Color color;

  const _ResourceStatCard({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // This block renders the stat icon.
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: color,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),

          // This block renders the stat label and count.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count.toString(),
                  style: const TextStyle(
                    color: Color(0xFF1C1C1E),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// This widget renders one dynamic awareness resource card.
class PracticalTipCard extends StatelessWidget {
  final tipsRightsModel tip;
  final VoidCallback onTap;

  const PracticalTipCard({
    required this.tip,
    required this.onTap,
  });

  // This helper returns the readable label for each content type.
  String _contentTypeLabel(AwarenessContentType type) {
    switch (type) {
      case AwarenessContentType.tip:
        return 'Tip';
      case AwarenessContentType.right:
        return 'Right';
      case AwarenessContentType.article:
        return 'Article';
      case AwarenessContentType.video:
        return 'Video';
    }
  }

  // This helper returns the icon for each content type.
  IconData _contentTypeIcon(AwarenessContentType type) {
    switch (type) {
      case AwarenessContentType.tip:
        return Icons.lightbulb_outline;
      case AwarenessContentType.right:
        return Icons.gavel_rounded;
      case AwarenessContentType.article:
        return Icons.article_outlined;
      case AwarenessContentType.video:
        return Icons.play_circle_outline;
    }
  }

  // This helper returns the accent color for each content type.
  Color _contentTypeColor(AwarenessContentType type) {
    switch (type) {
      case AwarenessContentType.tip:
        return const Color(0xFFF59E0B);
      case AwarenessContentType.right:
        return const Color(0xFF3B82F6);
      case AwarenessContentType.article:
        return const Color(0xFF10B981);
      case AwarenessContentType.video:
        return const Color(0xFFEF4444);
    }
  }

  // This helper returns a clean disability target preview.
  String _disabilityPreview() {
    if (tip.disabilityType.isEmpty) {
      return 'All disabilities';
    }

    return tip.disabilityType.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = _contentTypeColor(tip.contentType);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.18)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.035),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // This block renders the content type icon.
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  _contentTypeIcon(tip.contentType),
                  color: accentColor,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // This row renders content type, daily, and featured badges.
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _ResourceBadge(
                          label: _contentTypeLabel(tip.contentType),
                          color: accentColor,
                          icon: _contentTypeIcon(tip.contentType),
                        ),
                        if (tip.isDailyTip)
                          const _ResourceBadge(
                            label: 'Daily Tip',
                            color: Color(0xFFA855F7),
                            icon: Icons.today_outlined,
                          ),
                        if (tip.isFeatured)
                          const _ResourceBadge(
                            label: 'Featured',
                            color: Color(0xFF14B8A6),
                            icon: Icons.star_border_rounded,
                          ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // This text renders the resource title.
                    Text(
                      tip.title,
                      style: const TextStyle(
                        color: Color(0xFF1C1C1E),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // This text renders the resource description.
                    Text(
                      tip.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13.5,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // This block renders metadata such as disability types, read time, and URL presence.
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _MetaPill(
                          icon: Icons.accessibility_new_rounded,
                          text: _disabilityPreview(),
                        ),
                        if (tip.contentType == AwarenessContentType.article &&
                            tip.readTimeMinutes != null)
                          _MetaPill(
                            icon: Icons.timer_outlined,
                            text: '${tip.readTimeMinutes} min read',
                          ),
                        if (tip.contentType == AwarenessContentType.video)
                          _MetaPill(
                            icon: tip.mediaUrl == null ||
                                tip.mediaUrl!.trim().isEmpty
                                ? Icons.link_off_rounded
                                : Icons.link_rounded,
                            text: tip.mediaUrl == null ||
                                tip.mediaUrl!.trim().isEmpty
                                ? 'No URL'
                                : 'Video URL',
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // This icon indicates that the card opens the edit screen.
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// This widget renders a colored badge for content type and flags.
class _ResourceBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _ResourceBadge({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

// This widget renders neutral metadata pills.
class _MetaPill extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaPill({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F7),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.grey.withOpacity(0.16)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}