import 'package:flutter/material.dart';
import '../../../core/Styles/AppColors.dart';
import '../../../core/Styles/AppTextStyles.dart';
import 'metric_data.dart';


class StatCard extends StatelessWidget {
  final IconData icon;
  final String? title;           // ✅ nullable — no more isNotEmpty checks
  final List<MetricData> metrics;

  const StatCard({
    Key? key,
    required this.icon,
    required this.metrics,
    this.title,
  })  : assert(
  metrics.length >= 2 && metrics.length <= 4,
  'StatCard supports 2–4 metrics',
  ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 16),
          _buildMetrics(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(icon, size: 28, color: AppColors.primary),
        if (title != null)                // ✅ clean null check
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.border.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              title!,
              style: AppTextStyles.fieldLabel.copyWith(fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildMetrics() {
    if (metrics.length <= 3) return _buildRow(metrics);

    return Column(
      children: [
        _buildRow(metrics.sublist(0, 2)),
        const SizedBox(height: 16),
        const Divider(height: 1),
        const SizedBox(height: 16),
        _buildRow(metrics.sublist(2, 4)),
      ],
    );
  }

  Widget _buildRow(List<MetricData> items) {
    return Row(
      children: [
        for (int i = 0; i < items.length; i++) ...[
          if (i > 0) const _MetricDivider(),   // ✅ renamed — no longer shadows Flutter
          Expanded(
            child: _MetricItem(
              value: items[i].value,
              label: items[i].label,
            ),
          ),
        ],
      ],
    );
  }
}

class _MetricDivider extends StatelessWidget {       // ✅ was _VerticalDivider
  const _MetricDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 1,
      color: AppColors.border.withOpacity(0.4),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String value;
  final String label;

  const _MetricItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: AppTextStyles.largeTitle.copyWith(fontSize: 22),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.fieldLabel.copyWith(
            fontSize: 9,
            color: AppColors.textLight,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}