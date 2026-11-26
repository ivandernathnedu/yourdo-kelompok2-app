import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

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
                id: _generateUserId(),
                username: entry.key.trim(),
                passwordHash: _hashPassword(entry.value),
                createdAtIso: '',
              ),
        };

  static final Map<String, LocalUser> _persistedUsers = {
    'demo': const LocalUser(
      id: 'demo_user',
      username: 'demo',
      passwordHash:
          'ef92b778bafe771e89245b89ecbc08a44a4e166c06659911881f383d4473e94f',
      createdAtIso: '',
    ),
  };

  static final Random _random = Random.secure();

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

    final resolvedId = (_currentUser != null && _currentUser!.id.isNotEmpty)
        ? _currentUser!.id
        : MockProfileData.user.id;

    profileNotifier.value = UserProfile(
      id: resolvedId,
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
      final sep = Platform.pathSeparator;
      String? basePath;

      if (Platform.isWindows) {
        basePath = Platform.environment['LOCALAPPDATA'] ??
            Platform.environment['APPDATA'] ??
            Platform.environment['USERPROFILE'];
      } else if (Platform.isIOS || Platform.isMacOS) {
        final home = Platform.environment['HOME'];
        if (home != null && home.isNotEmpty) {
          basePath = '$home${sep}Documents';
        }
      } else if (Platform.isLinux) {
        basePath = Platform.environment['XDG_DATA_HOME'];
        if (basePath == null || basePath.isEmpty) {
          final home = Platform.environment['HOME'];
          if (home != null && home.isNotEmpty) {
            basePath = '$home$sep.local${sep}share';
          }
        }
      } else {
        basePath = Platform.environment['HOME'];
      }

      final root = (basePath != null && basePath.isNotEmpty)
          ? basePath
          : Directory.current.path;
      final appDir = Directory('$root${sep}yourdo_data');
      if (!appDir.existsSync()) {
        appDir.createSync(recursive: true);
      }
      return File('${appDir.path}${sep}yourdo_local_users.json');
    } catch (_) {
      return null;
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
    if (stored == null || stored.passwordHash != _hashPassword(password)) {
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
      id: _generateUserId(),
      username: trimmedUsername,
      passwordHash: _hashPassword(password),
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

  static String _generateUserId() {
    final ts = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
    final rand = List.generate(
      8,
      (_) => _random.nextInt(16).toRadixString(16),
    ).join();
    return 'usr_${ts}_$rand';
  }

  static String _hashPassword(String input) {
    final msg = utf8.encode(input);
    final bitLen = msg.length * 8;
    final paddedLen = ((msg.length + 9 + 63) ~/ 64) * 64;
    final buf = Uint8List(paddedLen);
    buf.setAll(0, msg);
    buf[msg.length] = 0x80;
    final bd = ByteData.sublistView(buf);
    bd.setUint64(paddedLen - 8, bitLen, Endian.big);

    const k = <int>[
      0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
      0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
      0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
      0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
      0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
      0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
      0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
      0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
    ];

    int h0 = 0x6a09e667;
    int h1 = 0xbb67ae85;
    int h2 = 0x3c6ef372;
    int h3 = 0xa54ff53a;
    int h4 = 0x510e527f;
    int h5 = 0x9b05688c;
    int h6 = 0x1f83d9ab;
    int h7 = 0x5be0cd19;

    int rotr(int x, int n) => ((x & 0xffffffff) >>> n) | ((x << (32 - n)) & 0xffffffff);

    final w = Uint32List(64);
    for (int offset = 0; offset < paddedLen; offset += 64) {
      for (int i = 0; i < 16; i++) {
        w[i] = bd.getUint32(offset + i * 4, Endian.big);
      }
      for (int i = 16; i < 64; i++) {
        final s0 = rotr(w[i - 15], 7) ^ rotr(w[i - 15], 18) ^ (w[i - 15] >>> 3);
        final s1 = rotr(w[i - 2], 17) ^ rotr(w[i - 2], 19) ^ (w[i - 2] >>> 10);
        w[i] = (w[i - 16] + s0 + w[i - 7] + s1) & 0xffffffff;
      }

      int a = h0, b = h1, c = h2, d = h3, e = h4, f = h5, g = h6, h = h7;
      for (int i = 0; i < 64; i++) {
        final s1 = rotr(e, 6) ^ rotr(e, 11) ^ rotr(e, 25);
        final ch = (e & f) ^ ((~e) & g);
        final temp1 = (h + s1 + ch + k[i] + w[i]) & 0xffffffff;
        final s0 = rotr(a, 2) ^ rotr(a, 13) ^ rotr(a, 22);
        final maj = (a & b) ^ (a & c) ^ (b & c);
        final temp2 = (s0 + maj) & 0xffffffff;

        h = g;
        g = f;
        f = e;
        e = (d + temp1) & 0xffffffff;
        d = c;
        c = b;
        b = a;
        a = (temp1 + temp2) & 0xffffffff;
      }

      h0 = (h0 + a) & 0xffffffff;
      h1 = (h1 + b) & 0xffffffff;
      h2 = (h2 + c) & 0xffffffff;
      h3 = (h3 + d) & 0xffffffff;
      h4 = (h4 + e) & 0xffffffff;
      h5 = (h5 + f) & 0xffffffff;
      h6 = (h6 + g) & 0xffffffff;
      h7 = (h7 + h) & 0xffffffff;
    }

    return [h0, h1, h2, h3, h4, h5, h6, h7]
        .map((v) => v.toRadixString(16).padLeft(8, '0'))
        .join();
  }
}
