enum ChatRole {
  user,
  assistant,
  unknown; // ? fallback

  // ? Helper to parse from string, with a fallback
  static ChatRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'user':
        return ChatRole.user;
      case 'assistant':
        return ChatRole.assistant;
      default:
        return ChatRole.unknown;
    }
  }
}
