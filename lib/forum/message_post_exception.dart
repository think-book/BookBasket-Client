class MessagePostException implements Exception {
  String errorMessage() {
    return 'Failed to post message.';
  }
}
