class LocalUser {
  const LocalUser({
    required this.id,
    required this.username,
    required this.passwordHash,
    required this.createdAtIso,
    this.displayName,
    this.bio,
    this.photoUrl,
  });

  final String id;
  final String username;
  final String passwordHash;
  final String createdAtIso;
  final String? displayName;
  final String? bio;
  final String? photoUrl;

  String get normalizedKey => username.trim().toLowerCase();

  LocalUser copyWith({
    String? id,
    String? username,
    String? passwordHash,
    String? createdAtIso,
    String? displayName,
    String? bio,
    String? photoUrl,
  }) {
    return LocalUser(
      id: id ?? this.id,
      username: username ?? this.username,
      passwordHash: passwordHash ?? this.passwordHash,
      createdAtIso: createdAtIso ?? this.createdAtIso,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'passwordHash': passwordHash,
      'createdAtIso': createdAtIso,
      if (displayName != null) 'displayName': displayName,
      if (bio != null) 'bio': bio,
      if (photoUrl != null) 'photoUrl': photoUrl,
    };
  }

  factory LocalUser.fromMap(Map<String, dynamic> map) {
    return LocalUser(
      id: map['id'] as String? ?? '',
      username: map['username'] as String? ?? '',
      passwordHash:
          (map['passwordHash'] ?? map['password']) as String? ?? '',
      createdAtIso: map['createdAtIso'] as String? ?? '',
      displayName: map['displayName'] as String?,
      bio: map['bio'] as String?,
      photoUrl: map['photoUrl'] as String?,
    );
  }
}
