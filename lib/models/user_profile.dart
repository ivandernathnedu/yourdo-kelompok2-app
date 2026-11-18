class UserProfile {
  const UserProfile({
    required this.id,
    required this.displayName,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
    required this.questsTaken,
    this.photoUrl,
  });

  final String id;
  final String displayName;
  final String username;
  final String bio;
  final int followers;
  final int following;
  final int questsTaken;
  final String? photoUrl;

  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;
}
