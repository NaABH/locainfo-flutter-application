// exceptions for location provider services

class LocationException implements Exception {
  const LocationException();
}

class CouldNotGetLocationException extends LocationException {}
