import 'package:flutter/material.dart';
import '../../models/garments_model.dart';

class GarmentItem extends StatelessWidget {
  final Garment garment;
  final bool isSelected;
  final VoidCallback onTap;

  const GarmentItem({
    super.key,
    required this.garment,
    required this.onTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.orange : Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Image.network(garment.imageUrl ?? '', width: 100, height: 100),
      ),
    );
  }
}
