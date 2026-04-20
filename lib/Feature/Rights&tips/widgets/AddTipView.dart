import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_qudra/Feature/Rights&tips/viewModel/right_tips_state.dart';
import 'package:admin_qudra/core/Models/tips&rightsModel.dart';
import '../viewModel/right_tips_cubit.dart';

class AddTipView extends StatefulWidget {
  const AddTipView({Key? key}) : super(key: key);

  @override
  State<AddTipView> createState() => _AddTipViewState();
}

class _AddTipViewState extends State<AddTipView> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _disabilityTypeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _disabilityTypeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final types = _disabilityTypeController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final newTip = tipsRightsModel(
      id: 0,
      createdAt: DateTime.now(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      disabilityType: types,
    );

    context.read<RightstipsCubit>().create(newTip);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RightstipsCubit, RightstipsState>(
      listener: (context, state) {
        if (state is RightstipsActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.green[600]),
          );
          Navigator.pop(context);
        } else if (state is RightstipsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red[600]),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F7),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF2F2F7),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1C1C1E)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Add Practical Tip',
            style: TextStyle(color: Color(0xFF1C1C1E), fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'New Tip',
                  style: TextStyle(color: Color(0xFF1C1C1E), fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Share helpful accessibility advice with the community.',
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),
                const SizedBox(height: 32),
                _buildLabel('Title'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _titleController,
                  hint: 'e.g. Clear Pathways',
                  validator: (v) => (v == null || v.isEmpty) ? 'Title is required' : null,
                ),
                const SizedBox(height: 20),
                _buildLabel('Description'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _descriptionController,
                  hint: 'Describe the tip in detail...',
                  maxLines: 4,
                  validator: (v) => (v == null || v.isEmpty) ? 'Description is required' : null,
                ),
                const SizedBox(height: 20),
                _buildLabel('Disability Types'),
                const SizedBox(height: 4),
                Text('Comma-separated  e.g. physical, visual', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _disabilityTypeController,
                  hint: 'physical, visual, hearing...',
                  validator: (v) => (v == null || v.isEmpty) ? 'At least one type required' : null,
                ),
                const SizedBox(height: 40),
                BlocBuilder<RightstipsCubit, RightstipsState>(
                  builder: (context, state) {
                    final isLoading = state is RightstipsLoading;
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1C1C1E),
                          disabledBackgroundColor: Colors.grey[300],
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: isLoading
                            ? const SizedBox(
                          height: 20, width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                            : const Text(
                          'Add Tip',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(color: Color(0xFF1C1C1E), fontSize: 14, fontWeight: FontWeight.w600),
  );

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: const TextStyle(color: Color(0xFF1C1C1E)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.withOpacity(0.2))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.withOpacity(0.2))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1C1C1E))),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.red[400]!)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.red[400]!)),
      ),
    );
  }
}