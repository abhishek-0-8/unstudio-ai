import 'package:flutter/foundation.dart';
import '../models/garments_model.dart';
import '../domain/garment_api.dart';

class GarmentController with ChangeNotifier {
  List<Garment> _topWear = [];
  List<Garment> _bottomWear = [];

  Garment? _selectedTopwear;
  Garment? _selectedBottomwear;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Garment> get topwear => _topWear;

  List<Garment> get bottomwear => _bottomWear;

  Garment? get selectedTopwear => _selectedTopwear;

  Garment? get selectedBottomwear => _selectedBottomwear;

  Future<void> fetchGarments() async {
    _isLoading = true;
    notifyListeners();

    try {
      final garmentsByCategory = await GarmentApi.fetchGarments();
      _topWear = garmentsByCategory['TOP'] ?? [];
      _bottomWear = garmentsByCategory['BOTTOM'] ?? [];
    } catch (e) {
      if (kDebugMode) {
        print('Failed to fetch garments: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectGarment(Garment garment) {
    if (garment.category?.toUpperCase() == 'TOP') {
      _selectedTopwear = garment;
    } else if (garment.category?.toUpperCase() == 'BOTTOM') {
      _selectedBottomwear = garment;
    }
    notifyListeners();
  }
}
