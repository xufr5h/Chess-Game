String getChatId(String user1, String user2) {
  // Ensure the IDs are in a consistent order to avoid duplicates
  return user1.hashCode <= user2.hashCode
      ? '$user1-$user2'
      : '$user2-$user1';
}