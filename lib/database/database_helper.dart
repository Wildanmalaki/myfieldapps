import 'package:MyField/fieldreview/models/field_review_model.dart';
import 'package:MyField/models/booking_model.dart';
import 'package:MyField/models/event_model.dart';
import 'package:MyField/models/user_model.dart';
import 'package:MyField/service/firebase_service.dart';

class DatabaseHelper {
  DatabaseHelper._init();

  static final DatabaseHelper instance = DatabaseHelper._init();
  static const String _usersCollection = 'users';
  static const String _bookingsCollection = 'bookings';
  static const String _reviewsCollection = 'reviews';
  static const String _eventsCollection = 'events';

  final FirebaseService _firebaseService = FirebaseService.instance;

  Future<int> insertUser(UserModel user) {
    return _firebaseService.createDocument(
      collectionPath: _usersCollection,
      data: user.toMap(),
      id: user.id,
    );
  }

  Future<UserModel?> loginUser(String email, String password) async {
    final result = await _firebaseService.getDocumentByFields(
      collectionPath: _usersCollection,
      filters: {
        'email': email,
        'password': password,
      },
    );

    if (result == null) {
      return null;
    }

    return UserModel.fromMap(result);
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final result = await _firebaseService.getDocumentByField(
      collectionPath: _usersCollection,
      field: 'email',
      value: email,
    );

    if (result == null) {
      return null;
    }

    return UserModel.fromMap(result);
  }

  Future<int> insertBooking(Booking booking) {
    return _firebaseService.createDocument(
      collectionPath: _bookingsCollection,
      data: booking.toMap(),
      id: booking.id,
    );
  }

  Future<List<Booking>> getBookings() async {
    final result = await _firebaseService.getDocuments(
      _bookingsCollection,
      orderBy: 'id',
      descending: true,
    );
    return result.map(Booking.fromMap).toList();
  }

  Future<int> deleteBooking(int id) async {
    await _firebaseService.deleteDocument(
      collectionPath: _bookingsCollection,
      id: id,
    );
    return 1;
  }

  Future<int> insertReview(FieldReview review) {
    return _firebaseService.createDocument(
      collectionPath: _reviewsCollection,
      data: review.toMap(),
      id: review.id,
    );
  }

  Future<List<FieldReview>> getReviews() async {
    final result = await _firebaseService.getDocuments(
      _reviewsCollection,
      orderBy: 'id',
      descending: true,
    );
    return result.map(FieldReview.fromMap).toList();
  }

  Future<int> deleteReview(int id) async {
    await _firebaseService.deleteDocument(
      collectionPath: _reviewsCollection,
      id: id,
    );
    return 1;
  }

  Future<int> insertEvent(EventModel event) {
    return _firebaseService.createDocument(
      collectionPath: _eventsCollection,
      data: event.toMap(),
      id: event.id,
    );
  }

  Future<List<EventModel>> getEvents() async {
    final result = await _firebaseService.getDocuments(
      _eventsCollection,
      orderBy: 'id',
      descending: true,
    );
    return result.map(EventModel.fromMap).toList();
  }

  Future<int> deleteEvent(int id) async {
    await _firebaseService.deleteDocument(
      collectionPath: _eventsCollection,
      id: id,
    );
    return 1;
  }
}
