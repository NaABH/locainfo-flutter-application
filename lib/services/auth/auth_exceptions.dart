// generic exceptions
class GenericAuthException implements Exception {}

// login: user not found in database
class UserNotFoundAuthException implements Exception {}

// login: incorrect password entered
class WrongPasswordAuthException implements Exception {}

// login: not logged in
class UserNotLoggedInAuthException implements Exception {}

// signup: weak password
class WeakPasswordAuthException implements Exception {}

// signup: email already registered
class EmailAlreadyInUseAuthException implements Exception {}

// ??
class InvalidEmailAuthException implements Exception {}
