class UserSession {
  static final UserSession _instance = UserSession._internal();

  factory UserSession() {
    return _instance;
  }

  UserSession._internal();

  int? _userId;
  String? _userType;

  void setUser(int id, String type) {
    _userId = id;
    _userType = type;
  }

  int? get userId => _userId;
  String? get userType => _userType;

  void clear() {
    _userId = null;
    _userType = null;
  }
}
