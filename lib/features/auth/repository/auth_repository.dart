import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:aad_oauth/aad_oauth.dart';
import 'package:aad_oauth/model/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:one/core/failuer.dart';
import 'package:one/core/models/ms_user_model.dart';
import 'package:one/core/models/user_model.dart';
import 'package:one/core/providers/firebase_providers.dart';
import 'package:one/core/type_defs.dart';
import 'package:one/main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final Config _config = Config(
  tenant: dotenv.env['TENANT']!,
  clientId: dotenv.env['CLIENT_ID']!,
  scope: "User.ReadBasic.All User.Read openid profile offline_access",
  // redirectUri is Optional as a default is calculated based on app type/web location
  redirectUri: "https://login.live.com/oauth20_desktop.srf",
  navigatorKey: navkey,
  // webUseRedirect:
  //     true, // default is false - on web only, forces a redirect flow instead of popup auth
  //Optional parameter: Centered CircularProgressIndicator while rendering web page in WebView
  loader: const Center(child: CircularProgressIndicator()),
);

final AadOAuth aadOAuth = AadOAuth(_config);

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: ref.read(authProvider),
    firestore: ref.read(storageProvider),
    googleSignIn: ref.read(googleSignInProvider),
    aadOAuth: aadOAuth,
  ),
);

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;
  final AadOAuth _aadOAuth;
  AuthRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
    required AadOAuth aadOAuth,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn,
        _aadOAuth = aadOAuth;

  Stream<User?> get authStateChange => _auth.authStateChanges();

  CollectionReference get _users => _firestore.collection('users');

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googelAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googelAuth?.accessToken,
        idToken: googelAuth?.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      UserModel userModel;
      // print(userCredential.additionalUserInfo!.isNewUser);
      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: userCredential.user!.displayName ?? "no name",
          email: userCredential.user!.email ?? "notfound@email.com",
          profilePic: userCredential.user!.photoURL ?? 'assets/defaultUser.jpg',
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          year: Batch(fromYear: 2022),
          department: Department.cse,
          section: Section.c,
          rollNO: "22481A05F2",
        );
        // print(userCredential.user!.email.toString());
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      return left(Failure(e.message.toString()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<MsUserModel> getCurrentUserDataFromMs(String accessToken) async {
    final response = await http.get(
      Uri.parse('https://graph.microsoft.com/v1.0/me'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    // Decode the JSON response.
    final user = MsUserModel.fromJson(response.body);
    return user;
  }

  Future<Stream<MsUserModel>> signIn(
    MsUserModel userModel,
    String accessToken,
  ) async {
    final snap = await _users.doc(userModel.id).get();
    if (!snap.exists) {
      String photoUrl =
          'https://firebasestorage.googleapis.com/v0/b/oneapp-af948.appspot.com/o/default%2Fdefaultimages.png?alt=media&token=b406faf9-6450-4055-99d3-6e7e3584e927&_gl=1*1xorfwr*_ga*NDEwNTg1MjYzLjE2ODU0NjIyNDc.*_ga_CW55HF8NVT*MTY5ODY4NDc5MS42Ny4xLjE2OTg2ODQ4NjEuNjAuMC4w';
      final response = await http.get(
        Uri.parse('https://graph.microsoft.com/v1.0/me/photo/\$value'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final file = await createTempFileFromPostRequestBody(response);
        log(file.path);
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profilePictures/${userModel.id}');

        try {
          //Store the file
          await storageRef.putFile(File(file.path));
          //Success: get the download URL
          photoUrl = await storageRef.getDownloadURL();
        } catch (error) {
          log(error.toString());
        }
      }
      log(userModel.jobTitle ?? 'not student');
      List<String>? roles = ['everyone'];
      if (userModel.jobTitle != null && userModel.jobTitle == "Student") {
        roles.add(userModel.jobTitle!);
        String branchCode = userModel.displayName.substring(6, 8);
        String batch = '${userModel.displayName.substring(0, 2)}Batch';
        Map<String, String> branchs = {
          "01": "CE",
          "02": "EEE",
          "03": "ME",
          "04": "ECE",
          "05": "CSE",
          "12": "IT",
          "42": "AIML",
          "54": "AIDS",
          "60": "IOT",
        };
        if (branchs.containsKey(branchCode)) {
          roles.add(branchs[branchCode]!);
        }
        roles.add(batch);
      }
      log(userModel.displayName.substring(6, 8));
      await _users
          .doc(userModel.id)
          .set(userModel.copyWith(photo: photoUrl, roles: roles).toMap());
    }
    return getMsUserData(userModel.id);
  }

  Future<File> createTempFileFromPostRequestBody(request) async {
    final tempFile = File('${Directory.systemTemp.path}/temp-file.jpeg');
    await tempFile.writeAsBytes(request.bodyBytes);
    return tempFile;
  }

  Stream<MsUserModel> getMsUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => MsUserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void logOut() async {
    await _aadOAuth.logout();
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
