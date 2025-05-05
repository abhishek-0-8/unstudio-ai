import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/garments_model.dart';

class GarmentApi {
  static const String _baseUrl =
      'https://fashionapp.getstudioai.com/api/garments/get-all-garments';

  static Future<Map<String, List<Garment>>> fetchGarments() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        final maleData = data['MALE'] as Map<String, dynamic>;
        final topList =
            (maleData['TOP'] as List<dynamic>)
                .map((e) => Garment.fromJson(e))
                .toList();
        final bottomList =
            (maleData['BOTTOM'] as List<dynamic>)
                .map((e) => Garment.fromJson(e))
                .toList();

        print("Garments: $data");
        return {'TOP': topList, 'BOTTOM': bottomList};
      } else {
        throw Exception(
          'Failed to load garments. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error fetching garments: $e');
      rethrow;
    }
  }
}
