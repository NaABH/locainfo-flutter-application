// exceptions for location provider services
class LocationException implements Exception {
  const LocationException();
}

class CouldNotGetLocationException extends LocationException {}

class CouldNotGetLastKnownLocationException extends LocationException {}

class CouldNotGetLiveLocationException extends LocationException {}
