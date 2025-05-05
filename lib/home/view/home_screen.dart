import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unstudio/home/view/widgets/garment_item.dart';
import 'package:unstudio/home/view/widgets/selected_preview.dart';

import '../controllers/garment_controller.dart';
import '../models/garments_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<GarmentController>(context, listen: false).fetchGarments();
  }

  Widget buildGarmentGrid(
    List garments,
    Garment? selected,
    Function(Garment) onSelect,
  ) {
    final itemsPerRow = (garments.length / 2).ceil();
    final row1 = garments.take(itemsPerRow).toList();
    final row2 = garments.skip(itemsPerRow).toList();

    return Column(
      children: [
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: row1.length,
            itemBuilder: (_, i) {
              final g = row1[i];
              return GarmentItem(
                garment: g,
                isSelected: selected?.id == g.id,
                onTap: () => onSelect(g),
              );
            },
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: row2.length,
            itemBuilder: (_, i) {
              final g = row2[i];
              return GarmentItem(
                garment: g,
                isSelected: selected?.id == g.id,
                onTap: () => onSelect(g),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GarmentController>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Select Garments')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => controller.fetchGarments(),
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Topwear',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          buildGarmentGrid(
            controller.topwear,
            controller.selectedTopwear,
            controller.selectGarment,
          ),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              'Bottomwear',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          buildGarmentGrid(
            controller.bottomwear,
            controller.selectedBottomwear,
            controller.selectGarment,
          ),
          const Spacer(),
          const SelectedPreview(),
        ],
      ),
    );
  }
}
