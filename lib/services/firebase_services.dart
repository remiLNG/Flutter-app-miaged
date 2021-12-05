import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String getUserId() {
    return _firebaseAuth.currentUser.uid;
  }

  final CollectionReference productsRef =
      FirebaseFirestore.instance.collection("Products");

  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection("Users");

  Future<void> getUserProductId() async {
    final collection = usersRef.doc(getUserId()).collection("Cart");
    var documentID;
    var querySnapshots = await collection.get();
    for (var snapshot in querySnapshots.docs) {
      documentID = snapshot.id; // <-- Document ID
    }
    return documentID;
  }

  void setUserInformation(
      {adresse, username, password, anniversaire, ville, pays, zipcode}) {
    try {
      FirebaseFirestore.instance
          .collection("UserInformation")
          .doc('MDoVfrZGV3dlq79Q9bya')
          .update({
        "Username": username,
        "Password": password,
        "Birthday": anniversaire,
        "Country": pays,
        "City": ville,
        "Address": adresse,
        "ZipCode": zipcode
      });
    } catch (e) {
      print(e.message);
    }
  }
}
