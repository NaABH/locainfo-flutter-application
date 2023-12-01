bool isInputValid(String content) {
  return content.trim().isNotEmpty && !RegExp(r'^[0-9\W_]').hasMatch(content);
}
