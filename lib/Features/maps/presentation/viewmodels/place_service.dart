// import 'package:takween/core/api/api_consumer.dart';

// class PlaceService {
//   final ApiConsumer api;

//   PlaceService(this.api);

//   static const String _baseUrl =
//       "https://maps.googleapis.com/maps/api/place";

//   static const String _apiKey = "your api key"; 

//   /// 🔍 Search places (autocomplete)
//   Future<List<Map<String, String>>> searchPlaces(String query) async {
//     if (query.isEmpty) return [];

//     try {
//       final response = await api.get(
//         "$_baseUrl/autocomplete/json",
//         queryParameters: {
//           "input": query,
//           "key": _apiKey,
//         },
//       );

//       final List predictions = response['predictions'];

//       return predictions.map((p) {
//         return {
//           'placeId': p['place_id'].toString(),
//           'description': p['description'].toString(),
//         };
//       }).toList();
//     } catch (e) {
//       throw Exception("Error searching places: $e");
//     }
//   }

//   /// 📍 Get latitude & longitude from placeId
//   Future<Map<String, double>?> getLatLng(String placeId) async {
//     try {
//       final response = await api.get(
//         "$_baseUrl/details/json",
//         queryParameters: {
//           "place_id": placeId,
//           "key": _apiKey,
//         },
//       );

//       final location =
//           response['result']['geometry']['location'];

//       return {
//         'lat': (location['lat'] as num).toDouble(),
//         'lng': (location['lng'] as num).toDouble(),
//       };
//     } catch (e) {
//       throw Exception("Error getting location: $e");
//     }
//   }
// }