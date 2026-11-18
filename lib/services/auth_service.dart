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
          'demo': 'password123',
          ...?seedUsers,
        };

  final Map<String, String> _users;

  Future<AuthResult> login({
    required String username,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final key = username.trim().toLowerCase();
    final stored = _users[key];
    if (stored == null || stored != password) {
      return const AuthResult.fail('Username atau password salah');
    }
    return const AuthResult.ok();
  }

  Future<AuthResult> signUp({
    required String username,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final key = username.trim().toLowerCase();
    if (_users.containsKey(key)) {
      return const AuthResult.fail('Username sudah terdaftar');
    }

    _users[key] = password;
    return const AuthResult.ok();
  }
}
