# Backend Integration Guide

This document explains how to integrate a backend API with the Hotel Reservation app.

## Current Architecture

The app currently uses the **Repository Pattern** with local Hive storage. This makes it easy to swap the data source without changing the business logic or UI.

### Current Structure

```
data/
├── models/           # Data models (UserModel, RoomModel, BookingModel)
├── repositories/     # Abstract repository interfaces
│   ├── user_repository.dart
│   ├── room_repository.dart
│   └── booking_repository.dart
└── local_db/
    ├── hive_service.dart
    └── local_*_repository.dart  # Local implementations
```

## Steps to Add Backend Integration

### 1. Create API Service

Create a new file `lib/data/api/api_service.dart`:

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'https://your-api.com/api';
  
  Future<dynamic> get(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    throw Exception('Failed to load data');
  }
  
  Future<dynamic> post(String endpoint, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    }
    throw Exception('Failed to post data');
  }
  
  // Add PUT, DELETE methods similarly
}
```

### 2. Create API Repository Implementations

Create `lib/data/repositories/api_user_repository.dart`:

```dart
import '../models/user_model.dart';
import 'user_repository.dart';
import '../api/api_service.dart';

class ApiUserRepository implements UserRepository {
  final ApiService _apiService;
  
  ApiUserRepository(this._apiService);
  
  @override
  Future<List<UserModel>> getAll() async {
    final data = await _apiService.get('users');
    return (data as List).map((json) => UserModel.fromJson(json)).toList();
  }
  
  @override
  Future<UserModel?> getById(String id) async {
    final data = await _apiService.get('users/$id');
    return UserModel.fromJson(data);
  }
  
  @override
  Future<void> create(UserModel user) async {
    await _apiService.post('users', user.toJson());
  }
  
  // Implement other methods...
}
```

Repeat for `ApiRoomRepository` and `ApiBookingRepository`.

### 3. Update Dependency Injection in main.dart

Replace the local repositories with API repositories:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize API service
  final apiService = ApiService();

  // Use API repositories instead of local
  final userRepository = ApiUserRepository(apiService);
  final roomRepository = ApiRoomRepository(apiService);
  final bookingRepository = ApiBookingRepository(apiService);

  // Rest remains the same
  final availabilityService = AvailabilityService(bookingRepository, roomRepository);
  final bookingService = BookingService(bookingRepository, availabilityService);

  Get.put(AuthController(userRepository));
  Get.put(RoomController(roomRepository));
  Get.put(BookingController(bookingService, availabilityService));
  Get.put(UserController(userRepository));

  runApp(const MyApp());
}
```

### 4. Add Authentication Token Handling

For authenticated APIs, modify `ApiService`:

```dart
class ApiService {
  String? _authToken;
  
  void setAuthToken(String token) {
    _authToken = token;
  }
  
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };
  
  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: _headers,
    );
    // ... rest of implementation
  }
}
```

### 5. Add http Package

Add to `pubspec.yaml`:

```yaml
dependencies:
  http: ^1.1.0
```

## Recommended Backend API Structure

### Endpoints

**Users:**
- `GET /api/users` - Get all users
- `GET /api/users/:id` - Get user by ID
- `POST /api/users` - Create user
- `PUT /api/users/:id` - Update user
- `DELETE /api/users/:id` - Delete user

**Rooms:**
- `GET /api/rooms` - Get all rooms
- `GET /api/rooms/:id` - Get room by ID
- `POST /api/rooms` - Create room
- `PUT /api/rooms/:id` - Update room
- `DELETE /api/rooms/:id` - Delete room

**Bookings:**
- `GET /api/bookings` - Get all bookings
- `GET /api/bookings/:id` - Get booking by ID
- `GET /api/bookings/user/:userId` - Get bookings by user
- `POST /api/bookings` - Create booking
- `PUT /api/bookings/:id` - Update booking
- `DELETE /api/bookings/:id` - Delete booking
- `GET /api/bookings/availability?roomId=:id&checkIn=:date&checkOut=:date` - Check availability

### Response Format

All responses should follow this format:

```json
{
  "success": true,
  "data": { ... },
  "message": "Success message"
}
```

Error responses:

```json
{
  "success": false,
  "error": "Error message",
  "code": "ERROR_CODE"
}
```

## Hybrid Approach (Offline-First)

For an offline-first approach, you can:

1. Keep both local and API repositories
2. Create a `HybridRepository` that:
   - Tries API first
   - Falls back to local storage on failure
   - Syncs local changes to API when online

Example:

```dart
class HybridUserRepository implements UserRepository {
  final ApiUserRepository _apiRepo;
  final LocalUserRepository _localRepo;
  
  @override
  Future<List<UserModel>> getAll() async {
    try {
      final users = await _apiRepo.getAll();
      // Cache locally
      for (var user in users) {
        await _localRepo.create(user);
      }
      return users;
    } catch (e) {
      // Fallback to local
      return await _localRepo.getAll();
    }
  }
}
```

## Testing

When testing with backend:

1. Start with mock API responses
2. Use tools like Postman to test endpoints
3. Implement error handling for network failures
4. Add loading states in UI
5. Test offline scenarios

## Summary

The repository pattern makes backend integration straightforward:

1. ✅ Models already have `toJson()` and `fromJson()` methods
2. ✅ Repository interfaces are already defined
3. ✅ Business logic is decoupled from data source
4. ✅ Just create API implementations and swap in `main.dart`

No changes needed to:
- Controllers
- UI screens
- Business logic services
- Models
