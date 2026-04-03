/// Model representing a place autocomplete suggestion.
class MapSuggestion {
  final String description;
  final String placeId;

  const MapSuggestion({
    required this.description,
    required this.placeId,
  });
}
