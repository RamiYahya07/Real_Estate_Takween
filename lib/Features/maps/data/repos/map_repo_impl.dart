import 'package:takween/Features/maps/data/repos/map_repo.dart';
import 'package:takween/core/api/api_consumer.dart';
import 'package:takween/core/api/server_strings.dart';
import 'package:takween/core/utils/helper/env.dart';

class MapRepoImpl implements MapRepo {
  final ApiConsumer api;

  MapRepoImpl(this.api);


  @override
  Future<List<Map<String, String>>> searchPlaces(String query) async {
    if (query.isEmpty) return [];

    try {
      final response = await api.get(
        "$kPlaceBaseUrl/autocomplete/json",
        queryParameters: {
          "input": query,
          "key": Env.googleMapKey,
        },
      );

      final List predictions = response['predictions'];

      return predictions.map((p) {
        return {
          'placeId': p['place_id'].toString(),
          'description': p['d escription'].toString(),
        };
      }).toList();
    } catch (e) {
      throw Exception("Search error: $e");
    }
  }

  @override
  Future<Map<String, double>?> getLatLng(String placeId) async {
    try {
      final response = await api.get(
        "$kPlaceBaseUrl/details/json",
        queryParameters: {
          "place_id": placeId,
          "key":Env.googleMapKey,
        },
      );

      final location =
          response['result']['geometry']['location'];

      return {
        'lat': (location['lat'] as num).toDouble(),
        'lng': (location['lng'] as num).toDouble(),
      };
    } catch (e) {
      throw Exception("Location error: $e");
    }
  }
}