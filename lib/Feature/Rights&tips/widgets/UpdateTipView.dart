import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admin_qudra/Feature/Rights&tips/viewModel/right_tips_state.dart';
import 'package:admin_qudra/core/Models/tips&rightsModel.dart';
import '../viewModel/right_tips_cubit.dart';

class UpdateTipView extends StatefulWidget {
  final tipsRightsModel tip;

  const UpdateTipView({
    Key? key,
    required this.tip,
  }) : super(key: key);

  @override
  State<UpdateTipView> createState() => _UpdateTipViewState();
}

class _UpdateTipViewState extends State<UpdateTipView> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;

  // This controller stores the optional video/article URL.
  late final TextEditingController _mediaUrlController;

  // This controller stores the optional article read time in minutes.
  late final TextEditingController _readTimeController;

  final _formKey = GlobalKey<FormState>();

  // This field stores the selected awareness content type.
  late AwarenessContentType _selectedContentType;

  // This set stores selected disability target values from fixed chips.
  late final Set<String> _selectedDisabilityTypes;

  // This flag controls whether the item can appear as a Daily Tip.
  late bool _isDailyTip;

  // This flag controls whether the item is highlighted as featured content.
  late bool _isFeatured;

  // This list defines fixed disability values to prevent typing mistakes.
  static const List<_DisabilityTypeOption> _disabilityOptions = [
    _DisabilityTypeOption(
      label: 'All',
      value: 'all',
      icon: Icons.dashboard_customize_outlined,
      color: Color(0xFF1C1C1E),
    ),
    _DisabilityTypeOption(
      label: 'Visual',
      value: 'visual',
      icon: Icons.visibility_outlined,
      color: Color(0xFF3B82F6),
    ),
    _DisabilityTypeOption(
      label: 'Hearing',
      value: 'hearing',
      icon: Icons.hearing_outlined,
      color: Color(0xFF14B8A6),
    ),
    _DisabilityTypeOption(
      label: 'Physical',
      value: 'physical',
      icon: Icons.accessibility_new_outlined,
      color: Color(0xFFF97316),
    ),
    _DisabilityTypeOption(
      label: 'Cognitive',
      value: 'cognitive',
      icon: Icons.psychology_outlined,
      color: Color(0xFFA855F7),
    ),
    _DisabilityTypeOption(
      label: 'Other',
      value: 'other',
      icon: Icons.more_horiz,
      color: Color(0xFF64748B),
    ),
  ];

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.tip.title);
    _descriptionController = TextEditingController(text: widget.tip.description);

    // This block initializes the new dynamic content fields from the existing model.
    _selectedContentType = widget.tip.contentType;
    _mediaUrlController = TextEditingController(text: widget.tip.mediaUrl ?? '');
    _readTimeController = TextEditingController(
      text: widget.tip.readTimeMinutes?.toString() ?? '',
    );
    _isDailyTip = widget.tip.isDailyTip;
    _isFeatured = widget.tip.isFeatured;

    // This block initializes selected disability chips from the saved model values.
    final normalizedTypes = widget.tip.disabilityType
        .map((type) => type.trim().toLowerCase())
        .where((type) => type.isNotEmpty)
        .toSet();

    _selectedDisabilityTypes = normalizedTypes.isEmpty
        ? {'all'}
        : normalizedTypes.contains('all')
        ? {'all'}
        : normalizedTypes;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _mediaUrlController.dispose();
    _readTimeController.dispose();
    super.dispose();
  }

  // This helper validates URLs for video/article media fields.
  bool _isValidUrl(String value) {
    final uri = Uri.tryParse(value.trim());
    return uri != null &&
        uri.hasScheme &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.trim().isNotEmpty;
  }

  // This helper returns selected disability types in a stable predefined order.
  List<String> _selectedDisabilityTypesList() {
    return _disabilityOptions
        .map((option) => option.value)
        .where((value) => _selectedDisabilityTypes.contains(value))
        .toList();
  }

  // This helper updates the selected disability chips while keeping the All option clean.
  void _toggleDisabilityType(String value) {
    setState(() {
      if (value == 'all') {
        _selectedDisabilityTypes
          ..clear()
          ..add('all');
        return;
      }

      _selectedDisabilityTypes.remove('all');

      if (_selectedDisabilityTypes.contains(value)) {
        _selectedDisabilityTypes.remove(value);
      } else {
        _selectedDisabilityTypes.add(value);
      }

      if (_selectedDisabilityTypes.isEmpty) {
        _selectedDisabilityTypes.add('all');
      }
    });
  }

  // This helper returns the readable label for each awareness content type.
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

  // This helper returns the page subtitle based on selected type.
  String _selectedTypeHelperText() {
    switch (_selectedContentType) {
      case AwarenessContentType.tip:
        return 'Short practical advice shown in the awareness hub.';
      case AwarenessContentType.right:
        return 'Legal or support-related accessibility rights.';
      case AwarenessContentType.article:
        return 'Longer awareness content with estimated reading time.';
      case AwarenessContentType.video:
        return 'Video awareness content using an external URL.';
    }
  }

  // This method validates the form and updates the awareness resource.
  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final selectedTypes = _selectedDisabilityTypesList();

    if (selectedTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select at least one disability type.'),
          backgroundColor: Colors.red[600],
        ),
      );
      return;
    }

    final int? readTime = _selectedContentType == AwarenessContentType.article
        ? int.tryParse(_readTimeController.text.trim())
        : null;

    final String? mediaUrl =
    (_selectedContentType == AwarenessContentType.video ||
        _selectedContentType == AwarenessContentType.article)
        ? _mediaUrlController.text.trim()
        : null;

    // This model is rebuilt fully to allow clearing media URL or read time when content type changes.
    final updated = tipsRightsModel(
      id: widget.tip.id,
      createdAt: widget.tip.createdAt,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      disabilityType: selectedTypes,
      contentType: _selectedContentType,
      mediaUrl: mediaUrl == null || mediaUrl.isEmpty ? null : mediaUrl,
      readTimeMinutes: readTime,
      isDailyTip: _isDailyTip,
      isFeatured: _isFeatured,
    );

    context.read<RightstipsCubit>().update(widget.tip.id, updated);
  }

  // This method shows a confirmation dialog before deleting the resource.
  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Resource',
          style: TextStyle(color: Color(0xFF1C1C1E)),
        ),
        content: Text(
          'Are you sure you want to delete "${widget.tip.title}"?',
          style: TextStyle(color: Colors.grey[600]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<RightstipsCubit>().delete(widget.tip.id);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RightstipsCubit, RightstipsState>(
      listener: (context, state) {
        if (state is RightstipsActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green[600],
            ),
          );
          Navigator.pop(context);
        } else if (state is RightstipsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red[600],
            ),
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
            'Edit Awareness Content',
            style: TextStyle(
              color: Color(0xFF1C1C1E),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: _confirmDelete,
              tooltip: 'Delete',
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // This block introduces the admin content update screen.
                const Text(
                  'Edit Resource',
                  style: TextStyle(
                    color: Color(0xFF1C1C1E),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Update tips, rights, articles, or video resources.',
                  style: TextStyle(color: Colors.grey[500], fontSize: 14),
                ),
                const SizedBox(height: 28),

                // This dropdown lets the admin update the awareness content type.
                _buildLabel('Content Type'),
                const SizedBox(height: 8),
                _buildContentTypeDropdown(),
                const SizedBox(height: 8),
                Text(
                  _selectedTypeHelperText(),
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                const SizedBox(height: 20),

                // This field updates the awareness content title.
                _buildLabel('Title'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _titleController,
                  hint: 'e.g. How to use voice commands',
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Title is required'
                      : null,
                ),
                const SizedBox(height: 20),

                // This field updates the awareness content description.
                _buildLabel('Description'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _descriptionController,
                  hint: 'Describe the resource in detail...',
                  maxLines: 4,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Description is required'
                      : null,
                ),
                const SizedBox(height: 20),

                // This optional URL field appears for video and article content.
                if (_selectedContentType == AwarenessContentType.video ||
                    _selectedContentType == AwarenessContentType.article) ...[
                  _buildLabel(
                    _selectedContentType == AwarenessContentType.video
                        ? 'Video URL'
                        : 'Article URL',
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _mediaUrlController,
                    hint: 'https://example.com/resource',
                    keyboardType: TextInputType.url,
                    validator: (v) {
                      if (_selectedContentType == AwarenessContentType.video) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Video URL is required';
                        }
                        if (!_isValidUrl(v)) {
                          return 'Enter a valid URL';
                        }
                      }

                      if (_selectedContentType ==
                          AwarenessContentType.article &&
                          v != null &&
                          v.trim().isNotEmpty &&
                          !_isValidUrl(v)) {
                        return 'Enter a valid URL';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                ],

                // This field appears only for articles to store estimated reading time.
                if (_selectedContentType == AwarenessContentType.article) ...[
                  _buildLabel('Read Time Minutes'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _readTimeController,
                    hint: 'e.g. 4',
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return null;

                      final value = int.tryParse(v.trim());
                      if (value == null || value <= 0) {
                        return 'Enter a valid positive number';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                ],

                // This selector prevents typo mistakes in disability types.
                _buildLabel('Disability Types'),
                const SizedBox(height: 6),
                Text(
                  'Choose one or more disability categories. Select All for general resources.',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
                const SizedBox(height: 10),
                _buildDisabilityTypeSelector(),

                const SizedBox(height: 20),

                // This switch updates whether this resource can appear as Daily Tip.
                _buildSwitchTile(
                  title: 'Daily Tip',
                  subtitle:
                  'Allow this resource to appear in the daily tip section.',
                  value: _isDailyTip,
                  onChanged: (value) {
                    setState(() {
                      _isDailyTip = value;
                    });
                  },
                ),
                const SizedBox(height: 12),

                // This switch updates whether this resource is featured.
                _buildSwitchTile(
                  title: 'Featured',
                  subtitle:
                  'Highlight this resource in featured awareness content.',
                  value: _isFeatured,
                  onChanged: (value) {
                    setState(() {
                      _isFeatured = value;
                    });
                  },
                ),

                const SizedBox(height: 40),

                // This button submits the updated dynamic awareness resource.
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Text(
                          'Save Changes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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

  // This widget renders a section label.
  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(
      color: Color(0xFF1C1C1E),
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  );

  // This widget renders the content type dropdown.
  Widget _buildContentTypeDropdown() {
    return DropdownButtonFormField<AwarenessContentType>(
      value: _selectedContentType,
      decoration: _inputDecoration('Select content type'),
      items: AwarenessContentType.values.map((type) {
        return DropdownMenuItem<AwarenessContentType>(
          value: type,
          child: Text(_contentTypeLabel(type)),
        );
      }).toList(),
      onChanged: (value) {
        if (value == null) return;

        setState(() {
          _selectedContentType = value;

          // This block clears type-specific fields when switching content type.
          if (value != AwarenessContentType.video &&
              value != AwarenessContentType.article) {
            _mediaUrlController.clear();
          }

          if (value != AwarenessContentType.article) {
            _readTimeController.clear();
          }
        });
      },
    );
  }

  // This widget renders a multi-select chip list for disability types.
  Widget _buildDisabilityTypeSelector() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _disabilityOptions.map((option) {
        final selected = _selectedDisabilityTypes.contains(option.value);

        return _DisabilityTypeChip(
          option: option,
          selected: selected,
          onTap: () => _toggleDisabilityType(option.value),
        );
      }).toList(),
    );
  }

  // This widget renders a reusable admin text field.
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Color(0xFF1C1C1E)),
      decoration: _inputDecoration(hint),
    );
  }

  // This widget renders a reusable switch tile.
  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Switch.adaptive(
            value: value,
            activeColor: const Color(0xFF1C1C1E),
            onChanged: onChanged,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1C1C1E),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // This helper builds consistent input decoration for all fields.
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400]),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1C1C1E)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red[400]!),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red[400]!),
      ),
    );
  }
}

// This model stores one fixed disability option used by the admin chips.
class _DisabilityTypeOption {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _DisabilityTypeOption({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
}

// This widget renders one selectable disability type chip.
class _DisabilityTypeChip extends StatelessWidget {
  final _DisabilityTypeOption option;
  final bool selected;
  final VoidCallback onTap;

  const _DisabilityTypeChip({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: selected ? option.color.withOpacity(0.10) : Colors.white,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected ? option.color : Colors.grey.withOpacity(0.22),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                option.icon,
                size: 16,
                color: selected ? option.color : Colors.grey[600],
              ),
              const SizedBox(width: 6),
              Text(
                option.label,
                style: TextStyle(
                  color: selected ? option.color : Colors.grey[700],
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (selected) ...[
                const SizedBox(width: 6),
                Icon(
                  Icons.check_rounded,
                  size: 15,
                  color: option.color,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}