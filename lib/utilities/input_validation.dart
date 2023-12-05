// validation of title, context, report content
bool isInputValid(String content) {
  return content.trim().isNotEmpty && !RegExp(r'^[0-9\W_]').hasMatch(content);
}

// validation of phone number field
bool isValidMalaysianPhoneNumber(String input) {
  if (RegExp(r'[a-zA-Z]').hasMatch(input)) {
    // contain alphabet
    return false;
  }
  // remove special character like 012-3456789
  String normalizedInput = input.replaceAll(RegExp(r'\D'), '');

  // start with '01' and have 10-11 digits in total
  final RegExp regex = RegExp(r'^01\d{8,9}$');
  return regex.hasMatch(normalizedInput);
}
