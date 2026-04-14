// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class FirebaseService {
//   static final FirebaseAuth _auth = FirebaseAuth.instance;
//   static final FirebaseFirestore _firebaseFirestore =
//       FirebaseFirestore.instance;

//   static Future<FirebaseService> registerUser({
//     required String email,
//     required String password,
//     required String username,
//   }) async {
//     final cred = await _auth.createUserWithEmailAndPassword(
//       email: email,
//       password: password,
//     );

//     final user = cred.user!;
//     final model = FirebaseService(
      
//     );

//     await _firebaseFirestore
//         .collection('users')
//         .doc(user.uid)
//         .set(model.toMap());

//     return model;
//   }
// }
