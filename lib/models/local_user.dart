class LocalUser {
  const LocalUser({
    required this.username,
    required this.password,
    required this.createdAtIso,
    this.displayName,
    this.bio,
    this.photoUrl,
  });

  final String username;
  final String password;
  final String createdAtIso;
  final String? displayName;
  final String? bio;
  final String? photoUrl;

  String get normalizedKey => username.trim().toLowerCase();

  LocalUser copyWith({
    String? username,
    String? password,
    String? createdAtIso,
    String? displayName,
    String? bio,
    String? photoUrl,
  }) {
    return LocalUser(
      username: username ?? this.username,
      password: password ?? this.password,
      createdAtIso: createdAtIso ?? this.createdAtIso,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'createdAtIso': createdAtIso,
      if (displayName != null) 'displayName': displayName,
      if (bio != null) 'bio': bio,
      if (photoUrl != null) 'photoUrl': photoUrl,
    };
  }

  factory LocalUser.fromMap(Map<String, dynamic> map) {
    return LocalUser(
      username: map['username'] as String? ?? '',
      password: map['password'] as String? ?? '',
      createdAtIso: map['createdAtIso'] as String? ?? '',
      displayName: map['displayName'] as String?,
      bio: map['bio'] as String?,
      photoUrl: map['photoUrl'] as String?,
    );
  }
}
