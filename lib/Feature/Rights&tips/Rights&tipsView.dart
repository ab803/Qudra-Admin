import 'package:admin_qudra/Feature/Rights&tips/viewModel/right_tips_cubit.dart';
import 'package:admin_qudra/Feature/Rights&tips/widgets/AddTipView.dart';
import 'package:admin_qudra/Feature/Rights&tips/widgets/UpdateTipView.dart';
import 'package:admin_qudra/core/Styles/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_qudra/Feature/Rights&tips/viewModel/right_tips_state.dart';
import 'package:admin_qudra/core/Models/tips&rightsModel.dart';

import '../Dashboard/widgets/Drawer.dart';

class RightstipsView extends StatelessWidget {
  const RightstipsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const QudraDrawer(),
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: BlocBuilder<RightstipsCubit, RightstipsState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildActionButtons(context),
                  const SizedBox(height: 32),
                  _buildSectionHeader(icon: Icons.lightbulb, title: 'Practical Tips'),
                  const SizedBox(height: 16),
                  if (state is RightstipsLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: CircularProgressIndicator(color: Color(0xFF1C1C1E)),
                      ),
                    )
                  else if (state is RightstipsError)
                    _buildErrorWidget(context, state.message)
                  else if (state is RightstipsLoaded)
                      _buildTipsList(context, state.tips)
                    else
                      const SizedBox.shrink(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTipsList(BuildContext context, List<tipsRightsModel> tips) {
    if (tips.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Text(
            'No tips yet. Add the first one!',
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tips.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final tip = tips[index];
        return PracticalTipCard(
          title: tip.title,
          description: tip.description,
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

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 36),
            const SizedBox(height: 8),
            Text(message, style: const TextStyle(color: Colors.redAccent, fontSize: 14), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.read<RightstipsCubit>().loadAll(),
              child: const Text('Retry', style: TextStyle(color: Color(0xFF1C1C1E))),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(

      backgroundColor: const Color(0xFFF2F2F7),
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF1C1C1E)),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: const Text(
        'Qudra Hub',
        style: TextStyle(color: Color(0xFF1C1C1E), fontWeight: FontWeight.bold, fontSize: 18),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CircleAvatar(
            backgroundColor: const Color(0xFFE5E5EA),
            radius: 16,
            child: const Text(
              'AP',
              style: TextStyle(color: Color(0xFF1C1C1E), fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }



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
            icon: const Icon(Icons.add_circle_outline, color: AppColors.white, size: 20),
            label: const Text('Add Tip', style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: AppColors.primary,
              side: BorderSide(color: Colors.grey.withOpacity(0.3)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),


      ],
    );
  }

  Widget _buildSectionHeader({required IconData icon, required String title, String? actionText}) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1C1C1E), size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Text(title, style: const TextStyle(color: Color(0xFF1C1C1E), fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        if (actionText != null)
          Text(actionText, style: TextStyle(color: Colors.grey[500], fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// ─── Cards ───────────────────────────────────────────────────────────────────


class PracticalTipCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onTap;

  const PracticalTipCard({
    Key? key,
    required this.title,
    required this.description,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(0.06)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.lightbulb, color: Color(0xFFF5A623), size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Color(0xFF1C1C1E), fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(description, style: TextStyle(color: Colors.grey[600], fontSize: 14, height: 1.4)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }
}