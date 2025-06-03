import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String email;
  final String accessToken;
  final String refreshToken;

  const AppUser({
    required this.email,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  List<Object> get props => [email, accessToken, refreshToken];

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "access_token": accessToken,
      "refresh_token": refreshToken,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> jsonUser) {
    try {
      final dynamic email = jsonUser['email'];
      final dynamic accessToken = jsonUser["access_token"];
      final dynamic refreshToken = jsonUser["refresh_token"];
      // ? validate top-level fields
      if (email == null || email is! String) {
        throw FormatException(
          "Invalid or missing 'email' ($email) in user JSON: $jsonUser",
        );
      }

      if (accessToken == null || accessToken is! String) {
        throw FormatException(
          "Invalid or missing 'accessToken' ($accessToken) in user JSON: $jsonUser",
        );
      }
      if (refreshToken == null || refreshToken is! String) {
        throw FormatException(
          "Invalid or missing 'refreshToken' ($refreshToken) in user JSON: $jsonUser",
        );
      }

      return AppUser(
        email: email,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    } catch (e) {
      //? log the error and the problematic JSON for debugging
      // print("Error parsing AppUser from JSON: $jsonUser");
      // print("Parsing Error: $e");
      //? rethrow a more specific error or handle as needed
      throw Exception("Failed to parse AppUser data: $e");
    }
  }
}
