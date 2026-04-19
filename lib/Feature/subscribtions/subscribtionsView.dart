import 'package:admin_qudra/Feature/subscribtions/viewModel/bundle_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/Styles/AppColors.dart';
import '../Dashboard/widgets/Drawer.dart';
import '../../../core/Models/BundleModel.dart';

class SubscribtionView extends StatelessWidget {
  const SubscribtionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Trigger the load as soon as the view is built
    context.read<BundleCubit>().loadBundles();

    return Scaffold(
      drawer: const QudraDrawer(),
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Subscription Bundles',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<BundleCubit, BundleState>(
        builder: (context, state) {
          if (state is BundleLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BundleLoaded) {
            if (state.bundles.isEmpty) {
              return const Center(child: Text("No bundles available."));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.bundles.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final bundle = state.bundles[index];
                return GestureDetector(
                  onTap: () {context.go('/update-bundle', extra: bundle); },
                  child: BundleCard(
                    bundle: bundle,
                    onDelete: () {
                      context.read<BundleCubit>().deleteBundle(bundle.id);
                    },
                  ),
                );
              },
            );
          } else if (state is BundleError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Start adding bundles!'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1E1E1E),
        onPressed: () => context.go('/AddBundle'),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class BundleCard extends StatelessWidget {
  final BundleModel bundle;
  final VoidCallback onDelete;

  const BundleCard({
    Key? key,
    required this.bundle,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if it's a draft based on your model's status string
    final bool isDraft = bundle.status.toUpperCase() == 'DRAFT';

    final textColor = isDraft ? Colors.grey.shade600 : Colors.black;
    final titleColor = isDraft ? Colors.grey.shade700 : Colors.black;
    final cardColor = isDraft ? Colors.grey.shade200 : Colors.white;

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if(!isDraft) BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                bundle.name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: titleColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDraft ? Colors.grey.shade300 : Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  bundle.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                    color: isDraft ? textColor : Colors.green.shade700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            bundle.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),
          // Example static feature list (or split your description if it's a list)
          _buildFeatureRow("Duration: ${bundle.duration} Days", isDraft, textColor),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '\$${bundle.price}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: titleColor,
                      ),
                    ),
                    TextSpan(
                      text: '/mo',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete_outline,
                  color: isDraft ? Colors.grey : Colors.redAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String text, bool isDraft, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            isDraft ? Icons.circle_outlined : Icons.check_circle,
            size: 18,
            color: isDraft ? Colors.grey.shade500 : Colors.black,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(fontSize: 15, color: textColor),
          ),
        ],
      ),
    );
  }
}