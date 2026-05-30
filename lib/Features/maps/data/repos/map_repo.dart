abstract class MapRepo {
  Future<List<Map<String, String>>> searchPlaces(String query);
  Future<Map<String, double>?> getLatLng(String placeId);
}