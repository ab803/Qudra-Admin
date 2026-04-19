import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/Models/institutionModel.dart';
import '../../core/Styles/AppColors.dart';
import '../../core/Styles/AppTextStyles.dart';
import '../Dashboard/widgets/Drawer.dart';
import '../institution/viewModel/institution_cubit.dart';
import '../institution/viewModel/institution_state.dart';
import '../institution/widgets/FilterRow.dart';
import '../institution/widgets/InstitutionCard.dart';
import '../institution/widgets/ManagementHeader.dart';
import '../institution/widgets/SearchBar.dart';

class InstitutionManagementView extends StatefulWidget {
  const InstitutionManagementView({Key? key}) : super(key: key);

  @override
  State<InstitutionManagementView> createState() =>
      _InstitutionManagementViewState();
}

class _InstitutionManagementViewState
    extends State<InstitutionManagementView> {
  String selectedStatus = 'all';
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<InstitutionCubit>().loadInstitutions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: QudraDrawer(),
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Qudra Admin', style: AppTextStyles.appBarTitle),
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: BlocBuilder<InstitutionCubit, InstitutionState>(
        builder: (context, state) {
          if (state is InstitutionLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is InstitutionError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is InstitutionLoaded) {
            // ================= FILTER + SEARCH LOGIC =================
            final filteredInstitutions = state.institutions.where((inst) {
              // STATUS FILTER
              final matchesStatus = selectedStatus == 'all'
                  ? true
                  : inst.status.toLowerCase() ==
                  selectedStatus.toLowerCase();

              // SEARCH FILTER
              final query = searchQuery.toLowerCase();

              final matchesSearch = searchQuery.isEmpty
                  ? true
                  : inst.name.toLowerCase().contains(query) ||
                  inst.email.toLowerCase().contains(query) ||
                  inst.institutionType.toLowerCase().contains(query);

              return matchesStatus && matchesSearch;
            }).toList();

            return RefreshIndicator(
              backgroundColor: AppColors.background,
              color: AppColors.primary,
              onRefresh: () =>
                  context.read<InstitutionCubit>().loadInstitutions(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ManagementHeader(),
                    const SizedBox(height: 24),

                    // ================= SEARCH BAR =================
                    CustomSearchBar(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value.toLowerCase();
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // ================= FILTER ROW =================
                    FilterRow(
                      selected: selectedStatus,
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value;
                        });
                      },
                    ),

                    const SizedBox(height: 24),

                    // ================= LIST =================
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredInstitutions.length,
                      separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final institution = filteredInstitutions[index];

                        return InstitutionCard(
                          institution: institution,
                          logoColor: AppColors.primary,
                          onDelete: () {
                            _showDeleteDialog(context, institution);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  // ================= DELETE DIALOG =================

  void _showDeleteDialog(BuildContext context, InstitutionModel inst) {
    showDialog(
      barrierColor: AppColors.background.withOpacity(0.5),
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Institution"),
        content: Text("Are you sure you want to delete ${inst.name}?"),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: AppColors.border.withOpacity(0.4),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              context
                  .read<InstitutionCubit>()
                  .deleteInstitution(inst.id);

              Navigator.pop(ctx);
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}