// validation of title, context, report content
bool isInputValid(String content) {
  return content.trim().isNotEmpty && !RegExp(r'^[0-9\W_]').hasMatch(content);
}

// validation of phone number field
// bool isValidMalaysianPhoneNumber(String phoneNum) {
//   String cleanedInput = phoneNum.replaceAll(RegExp(r'\D'), '');
//   final RegExp pattern = RegExp(r'^(01)[0-9]*[0-9]{7,8}$');
//   return pattern.hasMatch(cleanedInput);
// }

bool isValidMalaysianPhoneNumber(String phoneNumber) {
  // Remove special characters and trim the input
  String cleanedPhoneNumber =
      phoneNumber.replaceAll(RegExp(r'[^\d]'), '').trim();
  RegExp validPhoneNumberRegex = RegExp(
      r'^01[0-9]|011[0-9]|012[0-9]|013[0-9]|014[0-9]|015[0-9]|016[0-9]|017[0-9]|018[0-9]|019[0-9]');
  return validPhoneNumberRegex.hasMatch(cleanedPhoneNumber);
}
