import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/Models/ServicesModel.dart';
import '../../../core/Styles/AppColors.dart';
import '../../../core/Styles/AppTextStyles.dart';
import '../viewModel/serviceViewModel/service_cubit.dart';

class InstitutionalServicesScreen extends StatefulWidget {
  final String institutionId;

  const InstitutionalServicesScreen({
    Key? key,
    required this.institutionId,
  }) : super(key: key);

  @override
  State<InstitutionalServicesScreen> createState() =>
      _InstitutionalServicesScreenState();
}

class _InstitutionalServicesScreenState
    extends State<InstitutionalServicesScreen> {
  @override
  void initState() {
    super.initState();
    context
        .read<ServiceCubit>()
        .loadServicesByInstitution(widget.institutionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Navigation Bar ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 12.0),
              child: Row(
                children: [
                  const Icon(Icons.account_balance,
                      color: AppColors.primary, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Central University',
                    style:
                    AppTextStyles.appBarTitle.copyWith(fontSize: 16),
                  ),
                  const Spacer(),
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: AppColors.border,
                    child: Icon(Icons.person,
                        size: 20, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Screen Header ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: AppColors.primary),
                    onPressed: () => context.go('/institutions'),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Institutional Services',
                    style: AppTextStyles.screenTitle,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Body ────────────────────────────────────────────────────────
            Expanded(
              child: BlocConsumer<ServiceCubit, ServiceState>(
                listener: (context, state) {
                  if (state is ServiceError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                  if (state is ServiceDeleted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Service deleted successfully.'),
                      ),
                    );
                    context
                        .read<ServiceCubit>()
                        .loadServicesByInstitution(widget.institutionId);
                  }
                  if (state is ServiceUpdated) {
                    context
                        .read<ServiceCubit>()
                        .loadServicesByInstitution(widget.institutionId);
                  }
                },
                builder: (context, state) {
                  if (state is ServiceLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ServiceError) {
                    return _ErrorView(
                      message: state.message,
                      onRetry: () => context
                          .read<ServiceCubit>()
                          .loadServicesByInstitution(widget.institutionId),
                    );
                  }

                  final services = switch (state) {
                    ServicesLoaded s => s.services,
                    ServiceActionLoading s => s.currentServices,
                    _ => <ServiceModel>[],
                  };

                  final isActionLoading = state is ServiceActionLoading;

                  if (services.isEmpty) {
                    return const _EmptyView();
                  }

                  return Stack(
                    children: [
                      ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0)
                            .copyWith(bottom: 80),
                        itemCount: services.length,
                        separatorBuilder: (_, __) =>
                        const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final service = services[index];
                          return _ServiceCard(
                            service: service,
                            onToggleStatus: () =>
                                context.read<ServiceCubit>().toggleServiceStatus(
                                  service.id!,
                                  !service.isActive!,
                                ),
                            onDelete: () =>
                                _confirmDelete(context, service),
                            onEdit: () {
                              context.go('/ServiceDetails', extra: service); // Pass the model
                            },
                          );
                        },
                      ),
                      if (isActionLoading)
                        const Positioned.fill(
                          child: ColoredBox(
                            color: Colors.black12,
                            child: Center(
                                child: CircularProgressIndicator()),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, ServiceModel service) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Service'),
        content: Text(
            'Are you sure you want to delete "${service.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<ServiceCubit>().deleteService(service.id!);
            },
            child: const Text('Delete',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}

// ── Service Card ─────────────────────────────────────────────────────────────

class _ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;

  const _ServiceCard({
    Key? key,
    required this.service,
    required this.onEdit,
    required this.onDelete,
    required this.onToggleStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          // ── Top Row ───────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: service.isActive!
                      ? AppColors.primary
                      : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.miscellaneous_services,
                  color: AppColors.white,
                  size: 24,
                ),
              ),
              PopupMenuButton<_CardAction>(
                color: AppColors.background,
                onSelected: (action) {
                  switch (action) {
                    case _CardAction.edit:
                      onEdit();
                    case _CardAction.toggleStatus:
                      onToggleStatus();
                    case _CardAction.delete:
                      onDelete();
                  }
                },
                icon: Icon(Icons.more_vert,
                    color: AppColors.iconGrey, size: 20),
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: _CardAction.edit,
                    child: ListTile(
                      leading: Icon(Icons.edit_outlined),
                      title: Text('Edit'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    value: _CardAction.toggleStatus,
                    child: ListTile(
                      leading: Icon(service.isActive!
                          ? Icons.toggle_off_outlined
                          : Icons.toggle_on_outlined),
                      title: Text(
                          service.isActive! ? 'Deactivate' : 'Activate'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: _CardAction.delete,
                    child: ListTile(
                      leading:
                      Icon(Icons.delete_outline, color: Colors.redAccent),
                      title: Text('Delete',
                          style: TextStyle(color: Colors.redAccent)),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ── Title & Description ───────────────────────────────────────────
          Text(
            service.name!,
            style: AppTextStyles.fieldLabel
                .copyWith(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          if (service.description != null) ...[
            const SizedBox(height: 8),
            Text(
              service.description!,
              style: AppTextStyles.description.copyWith(height: 1.4),
            ),
          ],
          const SizedBox(height: 16),

          // ── Tags ──────────────────────────────────────────────────────────
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (service.category != null)
                _buildTag(service.category!.toUpperCase()),
              _buildTag(service.isActive! ? 'ACTIVE' : 'INACTIVE'),
              if (service.isFree!) _buildTag('FREE'),
              if (service.bookingType != null)
                _buildTag(service.bookingType!.toUpperCase()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text) {
    final isActive = text == 'ACTIVE';
    final isInactive = text == 'INACTIVE';

    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.shade50
            : isInactive
            ? Colors.red.shade50
            : AppColors.border.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          color: isActive
              ? Colors.green.shade700
              : isInactive
              ? Colors.red.shade700
              : AppColors.textPrimary,
        ),
      ),
    );
  }
}

enum _CardAction { edit, toggleStatus, delete }

// ── Empty State ───────────────────────────────────────────────────────────────

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.miscellaneous_services_outlined,
              size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No services yet',
            style: AppTextStyles.screenTitle
                .copyWith(color: Colors.grey.shade400),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add your first service.',
            style: AppTextStyles.description,
          ),
        ],
      ),
    );
  }
}

// ── Error State ───────────────────────────────────────────────────────────────

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(message,
                textAlign: TextAlign.center,
                style: AppTextStyles.description),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}