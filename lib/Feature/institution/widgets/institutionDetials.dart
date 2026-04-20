import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/Models/institutionModel.dart';
import '../../../core/Styles/AppColors.dart';
import '../../../core/Styles/AppTextStyles.dart';
import '../../../core/Utilities/getit.dart';
import '../viewModel/institution_cubit.dart';

class InstitutionDetailsScreen extends StatefulWidget {
  final InstitutionModel institution;

  const InstitutionDetailsScreen({
    Key? key,
    required this.institution,
  }) : super(key: key);

  @override
  State<InstitutionDetailsScreen> createState() =>
      _InstitutionDetailsScreenState();
}

class _InstitutionDetailsScreenState
    extends State<InstitutionDetailsScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController typeController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  String selectedStatus = 'pending';
  bool selectedSubscribed = false;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController(text: widget.institution.name);
    emailController = TextEditingController(text: widget.institution.email);
    typeController =
        TextEditingController(text: widget.institution.institutionType);
    phoneController =
        TextEditingController(text: widget.institution.phone ?? '');
    addressController =
        TextEditingController(text: widget.institution.address ?? '');

    selectedStatus = widget.institution.status;
    selectedSubscribed = widget.institution.subscribed;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    typeController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<InstitutionCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => context.go("/institutions"),
          ),
          title: Text(
            'Institution\nDetails',
            style: AppTextStyles.appBarTitle.copyWith(height: 1.2),
            maxLines: 2,
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildReadOnlyField('ID', widget.institution.id),
                const SizedBox(height: 24),

                _buildTextField('NAME', nameController),
                const SizedBox(height: 24),

                _buildTextField('EMAIL', emailController),
                const SizedBox(height: 24),

                _buildTextField('TYPE', typeController),
                const SizedBox(height: 24),

                _buildTextField('PHONE', phoneController),
                const SizedBox(height: 24),

                _buildDropdownField(),
                const SizedBox(height: 24),

                _buildSubscribedDropdown(), // 👈 add this
                const SizedBox(height: 24),

                _buildTextField('ADDRESS', addressController),
                const SizedBox(height: 40),

                /// 🔴 Discard
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => context.go("/institutions"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.border.withOpacity(0.4),
                    ),
                    child: Text('Discard',
                        style: AppTextStyles.button.copyWith(
                            color: AppColors.textPrimary)),
                  ),
                ),

                const SizedBox(height: 16),

                /// 🟢 Save
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _onSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: Text('SAVE CHANGES',
                        style: AppTextStyles.button),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= UI =================

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.fieldLabel),
        const SizedBox(height: 8),
        Text(value),
        const Divider(),
      ],
    );
  }

  Widget _buildSubscribedDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SUBSCRIBED', style: AppTextStyles.fieldLabel),
        DropdownButtonFormField<bool>(
          value: selectedSubscribed,
          items: const [
            DropdownMenuItem(value: true, child: Text('True')),
            DropdownMenuItem(value: false, child: Text('False')),
          ],
          onChanged: (val) {
            setState(() {
              selectedSubscribed = val!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.fieldLabel),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('STATUS', style: AppTextStyles.fieldLabel),
        DropdownButtonFormField<String>(
          value: selectedStatus,
          items: ['active', 'pending', 'refused']
              .map((val) => DropdownMenuItem(
            value: val,
            child: Text(val),
          ))
              .toList(),
          onChanged: (val) {
            setState(() {
              selectedStatus = val!;
            });
          },
        ),
      ],
    );
  }

  // ================= ACTION =================

  void _onSave() {
    final updated = widget.institution.copyWith(
      name: nameController.text,
      email: emailController.text,
      institutionType: typeController.text,
      phone: phoneController.text,
      address: addressController.text,
      status: selectedStatus,
      subscribed: selectedSubscribed,
    );

    context.read<InstitutionCubit>().updateInstitution(
      widget.institution.id,
      updated,
    );

    context.go("/institutions");
  }
}