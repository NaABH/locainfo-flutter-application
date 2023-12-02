class ProfileException implements Exception {
  const ProfileException();
}

// updating user name
class UsernameCouldNotBeEmptyProfileException extends ProfileException {}
