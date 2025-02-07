// generic exceptions
class GenericAuthException implements Exception {}

// login: user not found in database
class UserNotFoundAuthException implements Exception {}

// login: incorrect password entered
class WrongPasswordAuthException implements Exception {}

// login: could not sign in with google
class CouldNotSignInWithGoogleException implements Exception {}

// login: not logged in
class UserNotLoggedInAuthException implements Exception {}

// login: invalid email format or empty
class InvalidEmailAuthException implements Exception {}

// login: Account disabled
class AccountDisabledAuthException implements Exception {}

// signup: weak password
class WeakPasswordAuthException implements Exception {}

// signup: email already registered
class EmailAlreadyInUseAuthException implements Exception {}

// signup: username is empty
class InvalidUsernameAuthException implements Exception {}

// signup: password empty
class InvalidPasswordAuthException implements Exception {}
