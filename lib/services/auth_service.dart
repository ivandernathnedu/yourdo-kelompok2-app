import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../data/mock_profile_data.dart';
import '../models/local_user.dart';
import '../models/user_profile.dart';

class AuthResult {
  const AuthResult._({required this.success, this.message});

  const AuthResult.ok() : this._(success: true);

  const AuthResult.fail(String message)
      : this._(success: false, message: message);

  final bool success;
  final String? message;
}

class AuthService {
  AuthService({Map<String, String>? seedUsers})
      : _users = {
          if (seedUsers != null)
            for (final entry in seedUsers.entries)
              entry.key.trim().toLowerCase(): LocalUser(
                username: entry.key.trim(),
                password: entry.value,
                createdAtIso: '',
              ),
        };

  static final Map<String, LocalUser> _persistedUsers = {
    'demo': const LocalUser(
      username: 'demo',
      password: 'password123',
      createdAtIso: '',
    ),
  };

  static final ValueNotifier<UserProfile> profileNotifier =
      ValueNotifier<UserProfile>(MockProfileData.user);

  static LocalUser? _currentUser;
  static String? _customDisplayName;
  static String? _customBio;
  static String? _customPhotoUrl;
  static bool _initialized = false;

  final Map<String, LocalUser> _users;

  static String? get customDisplayName => _customDisplayName;
  static String? get customBio => _customBio;

  LocalUser? get currentUser => _currentUser;

  UserProfile get currentProfile => profileNotifier.value;

  static Future<void> init() async {
    _ensureInitialized();
  }

  static String formatUsernameFromEmail(String emailOrUsername) {
    final trimmed = emailOrUsername.trim().replaceFirst(RegExp(r'^@+'), '');
    if (trimmed.isEmpty) return MockProfileData.user.username;

    final localPart = trimmed.split('@').first;
    final lettersAndSpecial = localPart.replaceAll(RegExp(r'[0-9\s]+'), '');
    final handle =
        lettersAndSpecial.isNotEmpty ? lettersAndSpecial : localPart;
    return '@$handle';
  }

  static void _syncProfileNotifier() {
    final userDisplayName = _currentUser?.displayName;
    final resolvedDisplayName =
        (_customDisplayName != null && _customDisplayName!.trim().isNotEmpty)
            ? _customDisplayName!.trim()
            : (userDisplayName != null && userDisplayName.trim().isNotEmpty)
                ? userDisplayName.trim()
                : MockProfileData.user.displayName;

    final userBio = _currentUser?.bio;
    final resolvedBio = (_customBio != null && _customBio!.trim().isNotEmpty)
        ? _customBio!.trim()
        : (userBio != null && userBio.trim().isNotEmpty)
            ? userBio.trim()
            : MockProfileData.user.bio;

    final resolvedPhotoUrl =
        _customPhotoUrl ?? _currentUser?.photoUrl ?? MockProfileData.user.photoUrl;

    final resolvedUsername =
        (_currentUser != null && _currentUser!.username.trim().isNotEmpty)
            ? formatUsernameFromEmail(_currentUser!.username)
            : MockProfileData.user.username;

    profileNotifier.value = UserProfile(
      id: MockProfileData.user.id,
      displayName: resolvedDisplayName,
      username: resolvedUsername,
      bio: resolvedBio,
      followers: MockProfileData.user.followers,
      following: MockProfileData.user.following,
      questsTaken: MockProfileData.user.questsTaken,
      photoUrl: resolvedPhotoUrl,
    );
  }

  static void _ensureInitialized() {
    if (_initialized) return;
    _initialized = true;

    try {
      final file = _resolveStorageFile();
      if (file == null || !file.existsSync()) {
        _syncProfileNotifier();
        return;
      }

      final raw = file.readAsStringSync();
      if (raw.trim().isEmpty) {
        _syncProfileNotifier();
        return;
      }

      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        _syncProfileNotifier();
        return;
      }

      final usersList = decoded['users'];
      if (usersList is List) {
        for (final item in usersList) {
          if (item is Map<String, dynamic>) {
            final user = LocalUser.fromMap(item);
            if (user.normalizedKey.isNotEmpty) {
              _persistedUsers[user.normalizedKey] = user;
            }
          } else if (item is Map) {
            final user = LocalUser.fromMap(Map<String, dynamic>.from(item));
            if (user.normalizedKey.isNotEmpty) {
              _persistedUsers[user.normalizedKey] = user;
            }
          }
        }
      }

      final savedCustomName = decoded['customDisplayName'] as String?;
      if (savedCustomName != null && savedCustomName.trim().isNotEmpty) {
        _customDisplayName = savedCustomName.trim();
      }
      final savedCustomBio = decoded['customBio'] as String?;
      if (savedCustomBio != null && savedCustomBio.trim().isNotEmpty) {
        _customBio = savedCustomBio.trim();
      }
      final savedCustomPhoto = decoded['customPhotoUrl'] as String?;
      if (savedCustomPhoto != null && savedCustomPhoto.trim().isNotEmpty) {
        _customPhotoUrl = savedCustomPhoto;
      }

      final currentUsername = decoded['currentUsername'] as String?;
      if (currentUsername != null && currentUsername.trim().isNotEmpty) {
        _currentUser = _persistedUsers[currentUsername.trim().toLowerCase()];
      }
    } catch (_) {
      // Abaikan jika penyimpanan lokal belum tersedia atau rusak
    }

    _syncProfileNotifier();
  }

  static File? _resolveStorageFile() {
    try {
      final appFilesDir = Directory(
        '${Directory.systemTemp.parent.path}${Platform.pathSeparator}files',
      );
      if (!appFilesDir.existsSync()) {
        appFilesDir.createSync(recursive: true);
      }
      return File(
        '${appFilesDir.path}${Platform.pathSeparator}yourdo_local_users.json',
      );
    } catch (_) {
      try {
        return File(
          '${Directory.systemTemp.path}${Platform.pathSeparator}yourdo_local_users.json',
        );
      } catch (_) {
        return null;
      }
    }
  }

  static Future<void> _saveToDisk() async {
    try {
      final file = _resolveStorageFile();
      if (file == null) return;
      final payload = {
        'users': _persistedUsers.values.map((u) => u.toMap()).toList(),
        'currentUsername': _currentUser?.username,
        'customDisplayName': _customDisplayName,
        'customBio': _customBio,
        'customPhotoUrl': _customPhotoUrl,
      };
      file.writeAsStringSync(jsonEncode(payload));
    } catch (_) {
      // Abaikan jika environment tidak mengizinkan penulisan file lokal
    }
  }

  Future<AuthResult> login({
    required String username,
    required String password,
  }) async {
    _ensureInitialized();
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final key = username.trim().toLowerCase();
    final stored = _persistedUsers[key] ?? _users[key];
    if (stored == null || stored.password != password) {
      return const AuthResult.fail('Username atau password salah');
    }

    _currentUser = stored;
    _customDisplayName = stored.displayName;
    _customBio = stored.bio;
    _customPhotoUrl = stored.photoUrl;
    _syncProfileNotifier();
    await _saveToDisk();
    return const AuthResult.ok();
  }

  Future<AuthResult> signUp({
    required String username,
    required String password,
  }) async {
    _ensureInitialized();
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final trimmedUsername = username.trim();
    final key = trimmedUsername.toLowerCase();
    if (_persistedUsers.containsKey(key) || _users.containsKey(key)) {
      return const AuthResult.fail('Username sudah terdaftar');
    }

    final newUser = LocalUser(
      username: trimmedUsername,
      password: password,
      createdAtIso: DateTime.now().toIso8601String(),
    );
    _users[key] = newUser;
    _persistedUsers[key] = newUser;
    _currentUser = newUser;
    _syncProfileNotifier();
    await _saveToDisk();
    return const AuthResult.ok();
  }

  Future<void> updateProfile({
    required String displayName,
    String? bio,
    String? photoUrl,
  }) async {
    _ensureInitialized();
    _customDisplayName = displayName.trim();
    if (bio != null && bio.trim().isNotEmpty) {
      _customBio = bio.trim();
    }
    if (photoUrl != null) {
      _customPhotoUrl = photoUrl;
    }

    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        displayName: _customDisplayName,
        bio: _customBio,
        photoUrl: _customPhotoUrl,
      );
      _persistedUsers[_currentUser!.normalizedKey] = _currentUser!;
    }

    _syncProfileNotifier();
    await _saveToDisk();
  }

  Future<void> logout() async {
    _ensureInitialized();
    _currentUser = null;
    _customDisplayName = null;
    _customBio = null;
    _customPhotoUrl = null;
    _syncProfileNotifier();
    await _saveToDisk();
  }
}
