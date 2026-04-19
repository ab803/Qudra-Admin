import 'package:flutter/material.dart';
import 'AnimatedFilterChip.dart';

class FilterRow extends StatelessWidget {
  final String selected;
  final Function(String) onChanged;

  const FilterRow({
    Key? key,
    required this.selected,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final filters = ['all','active', 'pending', 'refused'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((status) {
          return GestureDetector(
            onTap: () => onChanged(status),
            child: AnimatedFilterChip(
              label: status,
              isSelected: selected == status,
              onTap: () => onChanged(status),
            ),
          );
        }).toList(),
      ),
    );
  }
}