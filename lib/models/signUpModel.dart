class Signupmodel {
  final String fullName;
  final String city;
  final String email;
  final String password;

  Signupmodel({
    required this.fullName,
    required this.city,
    required this.email,
    required this.password,
  });

  // Convert to JSON
  Map<String, String> toJson() {
    return {
      'fullName': fullName,
      'city': city,
      'email': email,
      'password': password,
    };
  }

  // Create from JSON
  factory Signupmodel.fromJson(Map<String, dynamic> json) {
    return Signupmodel(
      fullName: json['fullName'],
      city: json['city'],
      email: json['email'],
      password: json['password'],
    );
  }
}
