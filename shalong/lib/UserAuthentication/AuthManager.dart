import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class ShopInfo {
  String docId;
  String name;
  String address;
  String phone;
  bool isOpen;
  String shopratings;
  ShopInfo(this.docId, this.name, this.address, this.phone, this.isOpen ,this.shopratings);
}


class Profile {
  String docId;
  String name;
  String email;
  String phone;
  bool isBarber = false;
  String ratings;

  List<ShopInfo> shops = [];
  // String barbershopname;
  // String barbershopaddress;
  // String barberlocationurl;
  Profile(this.docId, this.name, this.email, this.phone, this.isBarber, this.shops,this.ratings);
}

Future<void> signout() async {
  (await GoogleSignIn().signOut());
  return FirebaseAuth.instance.signOut();
}

Future<Profile?> profile() async {

  var uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid != null) {
    CollectionReference userRef = FirebaseFirestore.instance.collection("user");
    var queryInfo = (await userRef.where("uid", isEqualTo: uid).get());
    var docs = queryInfo.docs;

    if (docs.length > 0) {
      var doc = queryInfo.docs.first;
      var name = doc["name"];
      var email = doc["email"];
      var phonenumber = doc["phone"];
      var isBarber = doc["is_barber"];
      var ratings = doc["ratings"];
      var docId = doc.id;
      List<ShopInfo> shops = [];

      CollectionReference userRef = FirebaseFirestore.instance.collection("shop");
      var shopQueryInfo = (await userRef.where("uid", isEqualTo: uid).get());
      var docs = shopQueryInfo.docs;
      if (docs.length > 0) {
        for (doc in docs) {
          shops.add(ShopInfo(doc.id, doc["name"], doc["address"], doc["phone"], doc["is_open"],doc["shopratings"]));
        }
      }
      return Profile(docId, name, email, phonenumber, isBarber, shops,ratings);
    }
  }
  return null;
}

Future<List<ShopInfo>?> fetchShops() async {
  CollectionReference shopRef = FirebaseFirestore.instance.collection("shop");
  var shopQueryInfo = (await shopRef.get());
  var docs = shopQueryInfo.docs;
  List<ShopInfo> shops = [];
  if (docs.length > 0) {
    for (var doc in docs) {
      var name = doc["name"] ?? "";
      var address = doc["address"] ?? "";
      var phonenumber = doc["phone"] ?? "";
      var isOpen = doc["is_open"];
      var shopratings = doc["shopratings"];
      shops.add(ShopInfo(doc.id, name, address, phonenumber, isOpen,shopratings));
    }
  }
  return shops;
}

setShopStatus(ShopInfo shop) {
  CollectionReference shopRef = FirebaseFirestore.instance.collection("shop");
   shopRef.doc(shop.docId).update({"is_open": shop.isOpen});
}



Future<UserCredential?> signInWithGoogle() async {

  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
  await googleUser?.authentication;
  if (googleAuth != null) {
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    var userCredentials =
    await FirebaseAuth.instance.signInWithCredential(credential);
    // Once signed in, return the UserCredential
    return userCredentials;
  }
}
