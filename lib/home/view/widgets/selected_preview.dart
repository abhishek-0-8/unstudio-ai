import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/garment_controller.dart';

class SelectedPreview extends StatelessWidget {
  const SelectedPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GarmentController>(context);

    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.black.withOpacity(0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (controller.selectedTopwear != null)
            Image.network(
              controller.selectedTopwear!.imageUrl ?? '',
              width: 100,
            ),
          const SizedBox(width: 16),
          if (controller.selectedBottomwear != null)
            Image.network(
              controller.selectedBottomwear!.imageUrl ?? '',
              width: 100,
            ),
        ],
      ),
    );
  }
}
