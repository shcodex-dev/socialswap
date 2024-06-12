// ignore_for_file: unnecessary_null_comparison

import 'dart:typed_data';

import 'package:socialswap/service/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DatabaseMethods {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> uploadImage(
      {required Uint8List bytes,
      required String id,
      required String folder}) async {
    try {
      Reference ref = _firebaseStorage.ref().child(folder).child(id);
      await ref.putData(bytes);
      String songCoverUrl = await ref.getDownloadURL();
      return songCoverUrl;
    } catch (exception) {
      return '';
    }
  }

  Future<String> updateImage({
    required Uint8List bytes,
    required String id,
    required String folder,
  }) async {
    try {
      Reference ref = _firebaseStorage.ref().child(folder).child(id);

      // Check if the image already exists
      if (await ref.getMetadata().then((metadata) => metadata != null)) {
        // Delete the existing image
        await ref.delete();
      }

      // Upload the new image
      await ref.putData(bytes);

      // Get the updated image URL
      String imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (exception) {
      return '';
    }
  }

  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future<QuerySnapshot> getUserbyemail(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("E-mail", isEqualTo: email)
        .get();
  }

  Future<QuerySnapshot> Search(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("SearchKey", isEqualTo: username.substring(0, 1).toUpperCase())
        .get();
  }

  createChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .get();
    if (snapshot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }

  Future addMessage(String chatRoomId, String messageId,
      Map<String, dynamic> messageInfoMap) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .doc(messageId)
        .set(messageInfoMap);
  }

  updateLastMessageSend(
      String chatRoomId, Map<String, dynamic> lastMessageInfoMap) {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .update(lastMessageInfoMap);
  }

  Future<Stream<QuerySnapshot>> getChatRoomMessages(chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)
        .snapshots();
  }

  Future<QuerySnapshot> getUserInfo(String username) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get();
  }

  Future<Stream<QuerySnapshot>> getChatRooms() async {
    String? myUsername = await SharedPreferenceHelper().getUserName();
    return FirebaseFirestore.instance
        .collection("chatrooms")
        .orderBy("time", descending: true)
        .where("users", arrayContains: myUsername!)
        .snapshots();
  }

  Future<void> updateUserName(
      String id, String newUserName, String newSearchKey) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({"username": newUserName, "SearchKey": newSearchKey});
  }

  Future<void> updateName(String id, String newName) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({"Name": newName});
  }

  Future<bool> checkIfUserNameExists(String username) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("username", isEqualTo: username)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  // getUserByUserId //
  Future getUserByUserId(String userId) async {
    return await FirebaseFirestore.instance.collection("users").doc(userId).get();
  }

  // updateUser //
  Future updateUser(String userId, Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update(userInfoMap);
  }
}
