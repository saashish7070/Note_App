class User {
  final String name;
  final String email;
  final String password;
  bool isLoggedIn;

  User({
    required this.name,
    required this.email,
    required this.password,
    this.isLoggedIn = false,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'isLoggedIn': isLoggedIn,
      };

  factory User.fromJson(Map<String, dynamic> userData) => User(
        name: userData['name']!,
        email: userData['email']!,
        password: userData['password']!,
        isLoggedIn: userData['isLoggedIn'] ?? false,
      );
}
