import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/Models/BundleModel.dart'; // Adjust path
import '../viewModel/bundle_cubit.dart'; // Adjust path

class UpdateBundleView extends StatefulWidget {
  final BundleModel bundle;

  const UpdateBundleView({Key? key, required this.bundle}) : super(key: key);

  @override
  State<UpdateBundleView> createState() => _UpdateBundleViewState();
}

class _UpdateBundleViewState extends State<UpdateBundleView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _durationController;
  late TextEditingController _descController;
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing bundle data
    _nameController = TextEditingController(text: widget.bundle.name);
    _priceController = TextEditingController(text: widget.bundle.price.toString());
    _durationController = TextEditingController(text: widget.bundle.duration.toString());
    _descController = TextEditingController(text: widget.bundle.description);
    _selectedStatus = widget.bundle.status.toUpperCase();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _descController.dispose();
    super.dispose();
  }

  // --- Aesthetic Constants matching the sketch ---
  static const Color primaryColor = Colors.black;
  static const double borderRadiusValue = 12.0;
  static const double fieldSpacing = 16.0;
  static const double textLeftPadding = 8.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Minimal app bar just for the back button
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Disabling standard back button
        title: GestureDetector(
          onTap: () => context.go("/subscribtions"),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: primaryColor, width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back, color: primaryColor),
          ),
        ),
      ),
      body: BlocListener<BundleCubit, BundleState>(
        listener: (context, state) {
          if (state is BundleActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            context.pop(); // Go back to list on success
          } else if (state is BundleError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (corresponds to the oval/empty text space in sketch)
                const Center(
                  child: Text(
                    "EDIT BUNDLE",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // --- Label + Black/White Input Field Construction ---

                // 1. NAME
                _buildFieldLabel("Bundle Name"),
                const SizedBox(height: 4),
                _buildTextFormField(
                  controller: _nameController,
                  validator: (v) => v!.isEmpty ? 'Name required' : null,
                ),
                const SizedBox(height: fieldSpacing),

                // 2. PRICE
                _buildFieldLabel("Price (\$)"),
                const SizedBox(height: 4),
                _buildTextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Price required' : null,
                ),
                const SizedBox(height: fieldSpacing),

                // 3. DURATION
                _buildFieldLabel("Duration (Days)"),
                const SizedBox(height: 4),
                _buildTextFormField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Duration required' : null,
                ),
                const SizedBox(height: fieldSpacing),

                // 4. STATUS (Dropdown matching the sketch border style)
                _buildFieldLabel("Status"),
                const SizedBox(height: 4),
                _buildStatusDropdown(),
                const SizedBox(height: fieldSpacing),

                // 5. DESCRIPTION
                _buildFieldLabel("Description"),
                const SizedBox(height: 4),
                _buildTextFormField(
                  controller: _descController,
                  maxLines: 4,
                  hintText: 'e.g. "Up to 10 Users..."',
                ),

                const SizedBox(height: 48),

                // --- SAVE BUTTON (matches primary black style) ---
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadiusValue),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'SAVE CHANGES',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32), // Bottom padding for scroll
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Reusable UI Builders for the Sketch Aesthetic ---

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: textLeftPadding),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Colors.black54,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    String? hintText,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black26),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        // --- Normal State Border ---
        enabledBorder: _outlinedBlackBorder,
        // --- Focus State Border ---
        focusedBorder: _outlinedBlackBorder.copyWith(borderSide: const BorderSide(width: 2)),
        // --- Error State Border ---
        errorBorder: _outlinedBlackBorder.copyWith(borderSide: const BorderSide(color: Colors.redAccent)),
        focusedErrorBorder: _outlinedBlackBorder.copyWith(borderSide: const BorderSide(color: Colors.redAccent, width: 2)),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(borderRadiusValue),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: _selectedStatus,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: primaryColor),
          decoration: const InputDecoration(border: InputBorder.none), // Remove default decoration
          icon: const Icon(Icons.keyboard_arrow_down, color: primaryColor),
          items: ['ACTIVE', 'DRAFT']
              .map((status) => DropdownMenuItem(value: status, child: Text(status)))
              .toList(),
          onChanged: (val) => setState(() => _selectedStatus = val!),
        ),
      ),
    );
  }

  OutlineInputBorder get _outlinedBlackBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadiusValue),
    borderSide: const BorderSide(color: primaryColor, width: 1.5),
  );

  // --- Submission Logic ---
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Use copyWith to retain id/createdAt and update the changed fields
      final updatedBundle = widget.bundle.copyWith(
        name: _nameController.text.trim(),
        price: int.tryParse(_priceController.text) ?? widget.bundle.price,
        duration: int.tryParse(_durationController.text) ?? widget.bundle.duration,
        status: _selectedStatus,
        description: _descController.text.trim(),
      );

      // Call the Cubit update method
      context.read<BundleCubit>().updateBundle(updatedBundle);
    }
  }
}