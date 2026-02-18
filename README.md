# Hotel Reservation App - MVP

A Flutter-based hotel reservation mobile application with role-based access control (Customer, Owner, Admin), local data persistence using Hive, and GetX for state management.

## 🚀 Features

### Customer Features
- ✅ Browse available hotel rooms
- ✅ View detailed room information (price, amenities, availability)
- ✅ Book rooms with calendar date selection
- ✅ View booking history
- ✅ Cancel bookings
- ✅ Date validation (no past dates, checkout after checkin)
- ✅ Real-time availability calculation

### Owner Features
- ✅ Dashboard with statistics
- ✅ Full CRUD operations for rooms
- ✅ View all users
- ✅ View and cancel all bookings
- ✅ Manage room pricing and features

### Admin Features
- ✅ System overview dashboard
- ✅ View all rooms, users, and bookings
- ✅ Cancel bookings
- ✅ Full system access

## 🏗️ Architecture

The app follows **Clean Architecture** principles with the **Repository Pattern**:

```
lib/
├── data/
│   ├── models/              # Data models with Hive adapters
│   ├── repositories/        # Abstract repository interfaces
│   └── local_db/           # Hive service and local implementations
├── domain/
│   └── services/           # Business logic services
├── presentation/
│   ├── controllers/        # GetX controllers
│   ├── screens/           # UI screens
│   └── widgets/           # Reusable widgets
├── routes/                # Navigation routes
└── utils/                 # Helper functions and constants
```

### Key Design Patterns

- **Repository Pattern**: Abstract data layer for easy backend integration
- **Dependency Injection**: GetX for managing dependencies
- **State Management**: GetX reactive state management
- **Navigation**: GetX routing

## 📦 Dependencies

```yaml
dependencies:
  get: ^4.6.6                    # State management & navigation
  hive: ^2.2.3                   # Local database
  hive_flutter: ^1.1.0           # Hive Flutter integration
  intl: ^0.18.1                  # Date formatting
  table_calendar: ^3.0.9         # Calendar widget
  uuid: ^4.0.0                   # UUID generation

dev_dependencies:
  hive_generator: ^2.0.1         # Hive code generation
  build_runner: ^2.4.6           # Build tools
```

## 🛠️ Setup Instructions

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK (3.0+)

### Installation

1. **Clone the repository**
   ```bash
   cd hotel-revervation
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters** (if needed)
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 📱 How to Use

### First Launch

On first launch, the app will:
1. Initialize Hive database
2. Seed dummy data:
   - 3 users (one per role)
   - 5 hotel rooms
   - 2 sample bookings

### Login

Select your role from the login screen:
- **Customer**: Browse and book rooms
- **Owner**: Manage rooms, users, and bookings
- **Admin**: Full system access

### Dummy Users

The app seeds these users:
- **Customer**: John Doe (john@customer.com)
- **Owner**: Sarah Smith (sarah@owner.com)
- **Admin**: Admin User (admin@hotel.com)

## 🎯 User Flows

### Customer Flow
1. Login as Customer
2. Browse rooms list
3. Tap on a room to view details
4. Click "Book Now"
5. Select check-in and check-out dates
6. Review booking summary
7. Confirm booking
8. View "My Bookings" to see all bookings
9. Cancel booking if needed

### Owner Flow
1. Login as Owner
2. View dashboard with statistics
3. Manage Rooms:
   - Add new rooms
   - Edit existing rooms
   - Delete rooms
4. View all users
5. View and cancel bookings

### Admin Flow
1. Login as Admin
2. View system dashboard
3. Access all rooms, users, and bookings
4. Cancel bookings as needed

## 💾 Data Models

### UserModel
```dart
{
  id: String,
  name: String,
  email: String,
  role: String  // 'customer', 'owner', 'admin'
}
```

### RoomModel
```dart
{
  id: String,
  name: String,
  type: String,
  price: double,
  totalRooms: int,
  features: List<String>,
  images: List<String>,
  description: String
}
```

### BookingModel
```dart
{
  id: String,
  userId: String,
  roomId: String,
  checkIn: DateTime,
  checkOut: DateTime,
  nights: int,
  totalPrice: double,
  status: String  // 'confirmed', 'cancelled'
}
```

## 🔄 Backend Integration

The app is designed for easy backend integration. See [BACKEND_INTEGRATION.md](BACKEND_INTEGRATION.md) for detailed instructions.

**Quick Summary:**
1. Create API service class
2. Implement API repository classes (ApiUserRepository, ApiRoomRepository, ApiBookingRepository)
3. Replace local repositories in `main.dart`
4. No changes needed to UI, controllers, or business logic!

## 🧪 Testing

Run Flutter analyzer:
```bash
flutter analyze
```

Run tests (when added):
```bash
flutter test
```

## 📂 Project Structure

```
hotel-revervation/
├── lib/
│   ├── data/
│   │   ├── models/
│   │   │   ├── user_model.dart
│   │   │   ├── room_model.dart
│   │   │   └── booking_model.dart
│   │   ├── repositories/
│   │   │   ├── user_repository.dart
│   │   │   ├── room_repository.dart
│   │   │   ├── booking_repository.dart
│   │   │   ├── local_user_repository.dart
│   │   │   ├── local_room_repository.dart
│   │   │   └── local_booking_repository.dart
│   │   └── local_db/
│   │       └── hive_service.dart
│   ├── domain/
│   │   └── services/
│   │       ├── availability_service.dart
│   │       └── booking_service.dart
│   ├── presentation/
│   │   ├── controllers/
│   │   │   ├── auth_controller.dart
│   │   │   ├── room_controller.dart
│   │   │   ├── booking_controller.dart
│   │   │   └── user_controller.dart
│   │   ├── screens/
│   │   │   ├── splash_screen.dart
│   │   │   ├── auth/
│   │   │   ├── customer/
│   │   │   ├── owner/
│   │   │   └── admin/
│   │   └── widgets/
│   │       ├── room_card.dart
│   │       └── booking_card.dart
│   ├── routes/
│   │   ├── app_routes.dart
│   │   └── app_pages.dart
│   ├── utils/
│   │   ├── constants.dart
│   │   └── date_helper.dart
│   └── main.dart
├── BACKEND_INTEGRATION.md
├── README.md
└── pubspec.yaml
```

## 🎨 UI/UX Features

- Material Design 3
- Responsive layouts
- Bottom navigation for customers
- Role-specific color schemes:
  - Customer: Green
  - Owner: Orange
  - Admin: Red
- Loading states
- Error handling
- Empty states
- Confirmation dialogs

## 🔐 Security Notes

**For MVP:**
- No password authentication (role selection only)
- No encryption
- Local storage only

**For Production:**
- Implement proper authentication (JWT, OAuth)
- Add password hashing
- Use HTTPS for API calls
- Implement role-based access control on backend
- Add data encryption

## 📝 Future Enhancements

- [ ] User registration and authentication
- [ ] Payment integration
- [ ] Email notifications
- [ ] Search and filter rooms
- [ ] Room reviews and ratings
- [ ] Multi-language support
- [ ] Dark mode
- [ ] Push notifications
- [ ] Analytics dashboard
- [ ] Export bookings to PDF

## 🤝 Contributing

This is an MVP project. For production use:
1. Add proper authentication
2. Integrate with backend API
3. Add comprehensive tests
4. Implement error handling
5. Add logging and analytics

## 📄 License

This project is for educational/demonstration purposes.

## 👨‍💻 Author

Built with Flutter, GetX, and Hive.

---

**Note**: This is an MVP (Minimum Viable Product) with local storage. See BACKEND_INTEGRATION.md for instructions on connecting to a real backend.
# Hotel-Reservation-App
# Hotel-Reservation-App---MVP
