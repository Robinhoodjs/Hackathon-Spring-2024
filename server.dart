import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hackaton/models/appuser.dart';
import 'package:hackaton/models/event.dart';
import 'package:hackaton/screens/login/auth_screen.dart';
import 'package:hackaton/values/colors.dart';
import 'package:hackaton/values/constant_functions.dart';
import 'package:http/http.dart' as http;

class Server {
  static Future<void> logOut() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
  }

  static bool isLogged() {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      return true;
    }
    return false;
  }

  static Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  static Future<void> authUser(String email, String password, String username,
      BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential authResult;

    authResult = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    FirebaseMessaging fbm = FirebaseMessaging.instance;
    String? token = await fbm.getToken();
    FirebaseFirestore.instance
        .collection('users')
        .doc(authResult.user!.uid)
        .set({
      'username': username,
      'email': email,
      'token': token,
    });
    await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<List<Event>> getSuggestedEvents(AppUser user) async {
    final List<Event> eventList = [];
    final QuerySnapshot<Map<String, dynamic>> events = await FirebaseFirestore
        .instance
        .collection('eventsPublish')
        .limit(10)
        .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> i in events.docs) {
      eventList.add(Event.fromMap(i.data()));
    }
    /*  for (int i = 0; i < EventList.length; i++) {
      EventList[i].pictures =
          await downloadImageToVariable(EventList[i].pictures);
    } */
    return eventList;
  }

  static Future<AppUser> getUserData() async {
    User user = FirebaseAuth.instance.currentUser!;
    final DocumentSnapshot<Map<String, dynamic>> userData =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
    AppUser toReturn = AppUser(
      userData.id,
      userData['email'],
      userData['username'],
      userData['facultaty'],
      userData['token'],
    );
    return toReturn;
  }

  static Future<List<Event>> getUserEvents(AppUser user) async {
    List<Event> userEvent = [];

    final QuerySnapshot<Map<String, dynamic>> userEvents =
        await FirebaseFirestore.instance
            .collection('eventsPublish')
            .where('idCreatedBy', isEqualTo: user.id)
            .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> i in userEvents.docs) {
      userEvent.add(Event.fromMap(i.data()));
    }
    for (int i = 0; i < userEvent.length; i++) {
      userEvent[i].listOfStringPictures = userEvent[i].pictures;
    }
    return userEvent;
  }

  static Future<void> deleteItemsFromDatabase(Event event) async {
    await deleteEvent(event);
  }

  static Future<List<Event>> getFavourite(List<String> listId) async {
    List<Event> eventList = [];
    final QuerySnapshot<Map<String, dynamic>> events = await FirebaseFirestore
        .instance
        .collection('eventsPublish')
        .where('id', whereIn: listId)
        .get();
    for (QueryDocumentSnapshot<Map<String, dynamic>> i in events.docs) {
      Event event = Event.fromMap(i.data());
      eventList.insert(0, event);
    }
    return eventList;
  }

  static Future<void> createEvent(Event event, List<String> indexList) async {
    await FirebaseFirestore.instance
        .collection('eventsPublish')
        .doc(event.id)
        .set({
      'id': event.id,
      'title': event.name,
      'description': event.description,
      'imageList': event.pictures,
      'indexList': indexList,
      'idCreatedBy': event.organizatorId,
      'facultaty': event.facultaty,
      'dateTime': event.time,
    });
  }

  static Future<String> putEventImage(
      String userId, String dateTime, int i, File imageList) async {
    final Reference ref = FirebaseStorage.instance
        .ref()
        .child('event_image')
        .child('$userId$dateTime$i.jpg');
    await ref.putFile(imageList);
    return await ref.getDownloadURL();
  }

  static Future<void> deleteImageFromDatabase(String id) async {
    await FirebaseStorage.instance.refFromURL(id).delete();
  }

  static Future<void> deleteUserAccount(
      String email, String password, BuildContext ctx) async {
    User user = FirebaseAuth.instance.currentUser!;
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();
      await FirebaseFirestore.instance
          .collection('eventsPublish')
          .where('createdBy', isEqualTo: user.uid)
          .get()
          .then((querySnapshot) {
        for (QueryDocumentSnapshot<Map<String, dynamic>> doc
            in querySnapshot.docs) {
          doc.reference.delete();
        }
      });
      user.delete();
    }).onError((error, stackTrace) {
      ConstantFunctions.showSnackBar(
        ctx,
        KColors.kErrorColor,
        KColors.kWhiteColor,
        error.toString(),
      );
    });
  }

  static Future<void> login(
      String email, String password, BuildContext context) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<List<Uint8List>> downloadImageToVariable(
      List<dynamic> image) async {
    final List<Uint8List> list = [];
    for (String element in image) {
      final http.Response temp = await http.get(Uri.parse(element));
      if (temp.statusCode == 200) {
        list.add(temp.bodyBytes);
      }
    }
    return list;
  }

  static Future<void> deleteEvent(Event event) async {
    await FirebaseFirestore.instance
        .collection('eventsPublish')
        .doc(event.id)
        .delete();
  }

  static Future<void> onDeleteReport(Event event) async {
    List<String> pictures = List<String>.from(event.pictures);

    await deleteEvent(event);

    for (String val in pictures) {
      await FirebaseStorage.instance.refFromURL(val).delete();
    }
  }

  static Future<List<Event>> onSearch(String query1, String userSchool) async {
    if (query1.contains('/*~~@(*%&%#')) {
      final QuerySnapshot<Map<String, dynamic>> event = await FirebaseFirestore
          .instance
          .collection('eventsPublish')
          .where('id', isEqualTo: query1)
          .get();
      return [Event.fromMap(event.docs[0].data())];
    }
    final String query = query1.toLowerCase();
    final List<Event> eventList = [];
    final QuerySnapshot<Map<String, dynamic>> events;

    events = await FirebaseFirestore.instance
        .collection('eventsPublish')
        .where(
          'indexList',
          arrayContains: query,
        )
        .limit(20)
        .get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> i in events.docs) {
      Event temp = Event.fromMap(i.data());
      eventList.add(temp);
    }

    return eventList;
  }

  static Future<void> signOut(BuildContext context) async {
    FirebaseAuth.instance.signOut();
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pushNamed(
      context,
      AuthScreen.routeName,
    );
  }
}
