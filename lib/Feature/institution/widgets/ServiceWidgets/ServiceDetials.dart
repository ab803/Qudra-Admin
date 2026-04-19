import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/Models/ServicesModel.dart';
import '../../viewModel/serviceViewModel/service_cubit.dart';


class ServiceDetailsView extends StatefulWidget {
  final ServiceModel service;

  const ServiceDetailsView({Key? key, required this.service}) : super(key: key);

  @override
  State<ServiceDetailsView> createState() => _ServiceDetailsViewState();
}

class _ServiceDetailsViewState extends State<ServiceDetailsView> {
  // ── Controllers ──────────────────────────────────────────────────────────
  late final TextEditingController _nameController;
  late final TextEditingController _categoryController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _durationController;
  late final TextEditingController _bookingTypeController;
  late final TextEditingController _availabilityController;

  // ── Local toggle state ────────────────────────────────────────────────────
  late bool _isActive;
  late bool _isFree;

  // ── Dropdown state ────────────────────────────────────────────────────────
  late String _locationMode;

  static const List<String> _locationModes = [
    'On-site Campus Clinic',
    'Telehealth',
    'Hybrid',
  ];

  @override
  void initState() {
    super.initState();
    final s = widget.service;
    _nameController         = TextEditingController(text: s.name ?? '');
    _categoryController     = TextEditingController(text: s.category ?? '');
    _descriptionController  = TextEditingController(text: s.description ?? '');
    _priceController        = TextEditingController(
        text: s.price != null ? s.price.toString() : '');
    _durationController     = TextEditingController(
        text: s.durationMinutes != null ? s.durationMinutes.toString() : '');
    _bookingTypeController  = TextEditingController(text: s.bookingType ?? '');
    _availabilityController = TextEditingController(
        text: s.availabilityNotes ?? '');

    _isActive    = s.isActive ?? false;
    _isFree      = s.isFree ?? false;
    _locationMode = (s.locationMode != null &&
        _locationModes.contains(s.locationMode))
        ? s.locationMode!
        : _locationModes.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    _bookingTypeController.dispose();
    _availabilityController.dispose();
    super.dispose();
  }

  // ── Build updated model from current form state ───────────────────────────
  ServiceModel _buildUpdatedModel() {
    return widget.service.copyWith(
      name:              _nameController.text.trim(),
      category:          _categoryController.text.trim(),
      description:       _descriptionController.text.trim(),
      price:             double.tryParse(_priceController.text.trim()),
      durationMinutes:   int.tryParse(_durationController.text.trim()),
      bookingType:       _bookingTypeController.text.trim(),
      availabilityNotes: _availabilityController.text.trim(),
      isActive:          _isActive,
      isFree:            _isFree,
      locationMode:      _locationMode,
    );
  }

  void _save() {
    context.read<ServiceCubit>().updateService(_buildUpdatedModel());
  }

  void _discard() => context.go('/Service');

  @override
  Widget build(BuildContext context) {
    const Color bgColor = Color(0xFFF7F7F7);

    return BlocConsumer<ServiceCubit, ServiceState>(
      listener: (context, state) {
        if (state is ServiceUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Service updated successfully.'),
              backgroundColor: Colors.green,
            ),
          );
          context.pop(); // Return to services list
        }

        if (state is ServiceError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ServiceActionLoading || state is ServiceLoading;

        return Stack(
          children: [
            Scaffold(
              backgroundColor: bgColor,
              appBar: _buildAppBar(),
              body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    _buildBasicInfoCard(),
                    const SizedBox(height: 16),
                    _buildStatusCard(),
                    const SizedBox(height: 16),
                    _buildPriceCard(),
                    const SizedBox(height: 16),
                    _buildDurationCard(),
                    const SizedBox(height: 32),
                    _buildSectionHeader('Logistics & Access'),
                    const SizedBox(height: 16),
                    _buildLogisticsCard(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
              bottomNavigationBar: _buildBottomActions(isLoading),
            ),

            // ── Full-screen loading overlay ───────────────────────────────
            if (isLoading)
              const Positioned.fill(
                child: ColoredBox(
                  color: Colors.black26,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        );
      },
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: _discard,
      ),
      title: const Text(
        'Service Details',
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
      actions: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _isActive ? Colors.black : Colors.grey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _isActive ? 'ACTIVE' : 'INACTIVE',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // ── Cards ─────────────────────────────────────────────────────────────────
  Widget _buildBasicInfoCard() {
    return _BaseCard(
      child: Column(
        children: [
          _InputField(label: 'Name', controller: _nameController),
          const SizedBox(height: 16),
          _InputField(label: 'Category', controller: _categoryController),
          const SizedBox(height: 16),
          _InputField(
            label: 'Description',
            controller: _descriptionController,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return _BaseCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _FieldLabel('Is Active'),
              Switch(
                value: _isActive,
                onChanged: (val) => setState(() => _isActive = val),
                activeColor: Colors.white,
                activeTrackColor: Colors.black,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _FieldLabel('Is Free'),
              Switch(
                value: _isFree,
                onChanged: (val) => setState(() => _isFree = val),
                activeColor: Colors.white,
                activeTrackColor: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCard() {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _FieldLabel('Price'),
          const SizedBox(height: 8),
          TextField(
            controller: _priceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF3F4F6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationCard() {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _FieldLabel('Duration (Minutes)'),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.timer_outlined, color: Colors.grey.shade500, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _durationController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        const SizedBox(height: 4),
        Container(height: 2, width: 140, color: Colors.black),
      ],
    );
  }

  Widget _buildLogisticsCard() {
    return _BaseCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _DropdownField(
            label: 'Location Mode',
            value: _locationMode,
            items: _locationModes,
            onChanged: (val) {
              if (val != null) setState(() => _locationMode = val);
            },
          ),
          const SizedBox(height: 16),
          _InputField(
              label: 'Booking Type', controller: _bookingTypeController),
          const SizedBox(height: 16),
          _InputField(
            label: 'Availability Notes',
            controller: _availabilityController,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(bool isLoading) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: const Color(0xFFF7F7F7),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: isLoading ? null : _discard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Discard',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: isLoading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2),
                )
                    : const Text('Save Changes',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable Components ───────────────────────────────────────────────────────

class _BaseCard extends StatelessWidget {
  final Widget child;
  const _BaseCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: child,
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
          letterSpacing: 1.0),
    );
  }
}

// ── Now accepts a controller instead of initialValue ─────────────────────────
class _InputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final int maxLines;

  const _InputField({
    required this.label,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF3F4F6),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          style:
          const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        ),
      ],
    );
  }
}

// ── Now accepts onChanged callback ────────────────────────────────────────────
class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(label),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF3F4F6),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          items: items
              .map((item) => DropdownMenuItem(
              value: item,
              child:
              Text(item, style: const TextStyle(fontSize: 14))))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}