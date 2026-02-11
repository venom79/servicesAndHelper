import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // ✅ IMPORTANT:
  // Android Emulator: http://10.0.2.2:5000
  // Physical device: http://YOUR_LAPTOP_IP:5000
  static const String baseUrl = "http://10.0.2.2:5000";

  static const Duration _timeout = Duration(seconds: 10);

  static Map<String, String> jsonHeaders({String? token}) {
    final headers = <String, String>{
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }
    return headers;
  }

  static dynamic _decode(http.Response res) {
    try {
      if (res.body.isEmpty) return {};
      return jsonDecode(res.body);
    } catch (_) {
      return {"message": res.body};
    }
  }

  static Exception _friendlyError(Object e) {
    if (e is SocketException) {
      return Exception(
        "Cannot reach server. Check baseUrl and make sure backend is running.",
      );
    }
    if (e.toString().contains("TimeoutException")) {
      return Exception(
        "Request timeout. Check baseUrl / network and backend status.",
      );
    }
    return Exception(e.toString().replaceFirst("Exception: ", ""));
  }

  static Exception _httpError(dynamic data, String fallback) {
    if (data is Map && data["message"] != null) {
      return Exception(data["message"].toString());
    }
    return Exception(fallback);
  }

  // ---------- AUTH ----------
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse("$baseUrl/api/auth/login"),
            headers: jsonHeaders(),
            body: jsonEncode({"email": email, "password": password}),
          )
          .timeout(_timeout);

      final data = _decode(res);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return Map<String, dynamic>.from(data);
      }
      throw _httpError(data, "Login failed");
    } catch (e) {
      throw _friendlyError(e);
    }
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role, // customer/provider
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse("$baseUrl/api/auth/register"),
            headers: jsonHeaders(),
            body: jsonEncode({
              "name": name,
              "email": email,
              "password": password,
              "role": role,
            }),
          )
          .timeout(_timeout);

      final data = _decode(res);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return Map<String, dynamic>.from(data);
      }
      throw _httpError(data, "Register failed");
    } catch (e) {
      throw _friendlyError(e);
    }
  }

  // ---------- PROVIDERS ----------
  static Future<List<dynamic>> getProviders({
    String? city,
    String? category,
    String? sort, // rating/price_low/price_high
  }) async {
    try {
      final qp = <String, String>{};
      if (city != null && city.isNotEmpty) qp["city"] = city;
      if (category != null && category.isNotEmpty) qp["category"] = category;
      if (sort != null && sort.isNotEmpty) qp["sort"] = sort;

      final uri =
          Uri.parse("$baseUrl/api/providers").replace(queryParameters: qp);

      final res = await http.get(uri).timeout(_timeout);
      final data = _decode(res);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return List<dynamic>.from(data);
      }
      throw _httpError(data, "Failed to fetch providers");
    } catch (e) {
      throw _friendlyError(e);
    }
  }

  static Future<Map<String, dynamic>> createProviderProfile({
    required String token,
    required String category,
    required String description,
    required String city,
    required int pricePerHour,
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse("$baseUrl/api/providers"),
            headers: jsonHeaders(token: token),
            body: jsonEncode({
              "category": category,
              "description": description,
              "city": city,
              "pricePerHour": pricePerHour,
            }),
          )
          .timeout(_timeout);

      final data = _decode(res);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return Map<String, dynamic>.from(data);
      }
      throw _httpError(data, "Failed to create provider profile");
    } catch (e) {
      throw _friendlyError(e);
    }
  }

  // ---------- BOOKINGS ----------
  static Future<Map<String, dynamic>> createBooking({
    required String token,
    required String providerId,
    required String date,
    required String timeSlot,
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse("$baseUrl/api/bookings"),
            headers: jsonHeaders(token: token),
            body: jsonEncode({
              "providerId": providerId,
              "date": date,
              "timeSlot": timeSlot,
            }),
          )
          .timeout(_timeout);

      final data = _decode(res);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return Map<String, dynamic>.from(data);
      }
      throw _httpError(data, "Booking failed");
    } catch (e) {
      throw _friendlyError(e);
    }
  }

  static Future<List<dynamic>> getBookings({
    required String token,
    String? status,
  }) async {
    try {
      final qp = <String, String>{};
      if (status != null && status.isNotEmpty) qp["status"] = status;

      final uri =
          Uri.parse("$baseUrl/api/bookings").replace(queryParameters: qp);

      final res = await http
          .get(uri, headers: jsonHeaders(token: token))
          .timeout(_timeout);

      final data = _decode(res);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return List<dynamic>.from(data);
      }
      throw _httpError(data, "Failed to fetch bookings");
    } catch (e) {
      throw _friendlyError(e);
    }
  }

  static Future<Map<String, dynamic>> updateBookingStatus({
    required String token,
    required String bookingId,
    required String status,
  }) async {
    try {
      final res = await http
          .put(
            Uri.parse("$baseUrl/api/bookings/$bookingId/status"),
            headers: jsonHeaders(token: token),
            body: jsonEncode({"status": status}),
          )
          .timeout(_timeout);

      final data = _decode(res);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return Map<String, dynamic>.from(data);
      }
      throw _httpError(data, "Failed to update status");
    } catch (e) {
      throw _friendlyError(e);
    }
  }

  // ---------- REVIEWS ----------
  static Future<Map<String, dynamic>> addReview({
    required String token,
    required String bookingId,
    required int rating,
    required String comment,
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse("$baseUrl/api/reviews"),
            headers: jsonHeaders(token: token),
            body: jsonEncode({
              "bookingId": bookingId,
              "rating": rating,
              "comment": comment,
            }),
          )
          .timeout(_timeout);

      final data = _decode(res);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return Map<String, dynamic>.from(data);
      }
      throw _httpError(data, "Failed to add review");
    } catch (e) {
      throw _friendlyError(e);
    }
  }

  static Future<List<dynamic>> getProviderReviews(String providerId) async {
    try {
      final res = await http
          .get(Uri.parse("$baseUrl/api/reviews/provider/$providerId"))
          .timeout(_timeout);

      final data = _decode(res);

      if (res.statusCode >= 200 && res.statusCode < 300) {
        return List<dynamic>.from(data);
      }
      throw _httpError(data, "Failed to fetch reviews");
    } catch (e) {
      throw _friendlyError(e);
    }
  }
}
