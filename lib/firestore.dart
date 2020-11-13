import 'package:cloud_firestore/cloud_firestore.dart';

class Fire {
  Firestore _firestore = Firestore.instance;

  Future<void> registerUser(String email, String password) async {
    return _firestore.collection('users').document(email).setData({
      'user-email': email,
      'user-password': password,
      'current-order' : {}
    });
  }

  Future<void> placeOrder(
    Map o,
    String email,
  ) async {
    return _firestore
        .collection('users')
        .document(email)
        .updateData({
      'current-order': o,
    });
  }

  Future<void> updateWallet(double wallet, String email) async {
    return _firestore.collection('users').document(email).updateData({
      'wallet-balance': wallet,
    });
  }

  Future<void> pastOrders(Map pastOrders, String email) async {
    return _firestore.collection('users').document(email).updateData({
      'past-orders': pastOrders,
    });
  }

  Future<int> logIn(String email, String password) async {
    final QuerySnapshot result = await _firestore
        .collection('users')
        .where('user-email', isEqualTo: email)
        .where('user-password', isEqualTo: password)
        .getDocuments();
    final List<DocumentSnapshot> docs = result.documents;

    if (docs.length == 0) {
      return 0;
    } else {
      return 1;
    }
  }
}
