import 'dart:async';
import 'dart:developer';
import 'dart:io';

// import 'package:aad_oauth/aad_oauth.dart';
// import 'package:aad_oauth/model/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:one/bot.dart';
import 'package:one/core/failuer.dart';
import 'package:one/core/models/ms_user_model.dart';
import 'package:one/core/models/user_model.dart';
import 'package:one/core/providers/firebase_providers.dart';
import 'package:one/core/type_defs.dart';
import 'package:one/features/auth/controller/auth_controller.dart';
import 'package:one/features/home/screens/api_controller.dart';
import 'package:one/features/posts/screens/post_page.dart';
import 'package:one/features/settings/screens/attendance_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// final Config _config = Config(
//   tenant: dotenv.env['TENANT']!,
//   clientId: dotenv.env['CLIENT_ID']!,
//   scope:
//       "User.ReadBasic.All User.Read openid profile offline_access Files.Read.All",
//   // redirectUri is Optional as a default is calculated based on app type/web location
//   redirectUri: "https://login.live.com/oauth20_desktop.srf",
//   navigatorKey: navkey,
//   // webUseRedirect:
//   //     true, // default is false - on web only, forces a redirect flow instead of popup auth
//   //Optional parameter: Centered CircularProgressIndicator while rendering web page in WebView
//   loader: const Center(child: CircularProgressIndicator()),
// );

// final AadOAuth aadOAuth = AadOAuth(_config);

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    auth: ref.read(authProvider),
    firestore: ref.read(storageProvider),
    // googleSignIn: ref.read(googleSignInProvider),
    // aadOAuth: aadOAuth,
  ),
);

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  // final GoogleSignIn _googleSignIn;
  // final AadOAuth _aadOAuth;
  AuthRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    // required GoogleSignIn googleSignIn,
    // required AadOAuth aadOAuth,
  })  : _auth = auth,
        _firestore = firestore
  // _googleSignIn = googleSignIn
  // _aadOAuth = aadOAuth
  ;
  UserCredential? _userCredential;

  Stream<User?> get authStateChange => _auth.authStateChanges();

  CollectionReference get _users => _firestore.collection('users');

  FutureEither<UserModel> signInWithMS(
    String prompt,
    String mail,
  ) async {
    try {
      MicrosoftAuthProvider msAuthProvider = MicrosoftAuthProvider();
      msAuthProvider.addScope("offline_access");
      msAuthProvider.addScope("User.Read");
      msAuthProvider.addScope("User.ReadBasic.All");
      msAuthProvider.addScope("profile");

      msAuthProvider.setCustomParameters({
        "prompt": prompt,
        "tenant": "organizations",
        "login_hint": mail,
        "domain_hint": "gecgudlavallerumic.in"
      });
      if (kIsWeb) {
        _userCredential = await _auth.signInWithPopup(msAuthProvider);
      } else {
        _userCredential = await _auth.signInWithProvider(msAuthProvider);
      }

      // getCurrentUserDataFromMs(userCredential.credential!.accessToken ?? '');
      UserModel userModel;
      // log(_userCredential!.credential!.accessToken.toString());
      // log(_userCredential!.toString());

      if (_userCredential!.additionalUserInfo!.isNewUser) {
        userModel = await createAccountForDB();
      } else {
        var userInDB = await getCurrentUserData(_userCredential!.user!.uid);
        if (userInDB != null) {
          userModel = await userInDB.first;
        } else {
          log("account not found in DB");
          userModel = await createAccountForDB();
        }
        // log(userModel.toString());
      }
      // _firestore
      //     .collectionGroup("registered")
      //     .where("name", isEqualTo: "noob")
      //     .snapshots()
      //     .first
      //     .then((value) {
      //   for (var e in value.docs) {
      //     log("${e.id} ${e.data().toString()} ${e.reference.path}  ${e.reference.parent.parent!.id}");
      //   }
      // });
      // log(_auth.authStateChanges().first.toString());
      // log(_userCredential!.additionalUserInfo.toString());
      return right(userModel);
    } on FirebaseException catch (e) {
      // log(e.message.toString());
      // log(e.toString());
      return left(Failure(e.code));
    } catch (e) {
      // log(e.toString());
      return left(Failure(e.toString()));
    }
  }

  Future<http.Response> getImage() async {
    final response = await http.get(
      Uri.parse('https://graph.microsoft.com/v1.0/me/photo/\$value'),
      headers: {
        'Authorization': 'Bearer ${_userCredential!.credential!.accessToken}',
        'Content-Type': 'application/json',
      },
    );
    return response;
  }

  Future<UserModel> createAccountForDB() async {
    log("New user");
    String photoUrl = const String.fromEnvironment('PROFILE_ICON_URL');

    // final response = await http.get(
    //   Uri.parse('https://graph.microsoft.com/v1.0/me/photo/\$value'),
    //   headers: {
    //     'Authorization': 'Bearer ${_userCredential!.credential!.accessToken}',
    //     'Content-Type': 'application/json',
    //   },
    // );
    // if (response.statusCode == 200) {
    //   final file = await createTempFileFromPostRequestBody(response);
    //   // log(file.path);
    //   final storageRef = FirebaseStorage.instance
    //       .ref()
    //       .child('profilePictures/${_userCredential!.user!.uid}');

    //   try {
    //     //Store the file
    //     await storageRef.putFile(File(file.path));
    //     //Success: get the download URL
    //     photoUrl = await storageRef.getDownloadURL();
    //   } catch (error) {
    //     // log(error.toString());
    //     rethrow;
    //   }
    // }
    final String fullName =
        _userCredential!.additionalUserInfo!.profile!['givenName'] +
            " " +
            _userCredential!.additionalUserInfo!.profile!['surname'];
    var theName = [];
    fullName.split(" ").forEach((e) {
      theName.add(e.capitalize());
    });
    // ^\d{5}[A-Z]{1}\d{2}[A-Z\d]\d$
    final rollRegex = RegExp(r"^\d{5}[A-Z]{1}\d{2}[A-Z\d]\d$");
    final String mailName =
        _userCredential!.additionalUserInfo!.profile!['mail']!.split('@')[0];
    int? out;
    if (rollRegex.hasMatch(mailName)) {
      out = int.parse(
          "20${mailName[4] == '1' ? mailName.substring(0, 2) : (int.parse(mailName.substring(0, 2)) - 1)}");
      out = out - 2000;
      out = out + 4;
    }
    UserModel userModel = UserModel(
      name: theName.join(" "),
      email: _userCredential!.additionalUserInfo!.profile!['mail'] ??
          "notfound@email.com",
      profilePic: photoUrl,
      uid: _userCredential!.user!.uid,
      oid: _userCredential!.additionalUserInfo!.profile!['id'],
      phoneNo: _userCredential!.additionalUserInfo!.profile?['mobilePhone'],
      rollNO: rollRegex.hasMatch(mailName) ? mailName : null,
      out: out,
      roles:
          (_userCredential!.additionalUserInfo!.profile!['jobTitle'] != 'null')
              ? [_userCredential!.additionalUserInfo!.profile!['jobTitle']]
              : [],
      lastSignInTime: _userCredential!.user!.metadata.lastSignInTime!,
    );
    // log(userModel.toString());
    await _users.doc(_userCredential!.user!.uid).set(userModel.toMap());
    return userModel;
  }

  // FutureEither<UserModel> signInWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     final googelAuth = await googleUser?.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googelAuth?.accessToken,
  //       idToken: googelAuth?.idToken,
  //     );

  //     UserCredential userCredential =
  //         await _auth.signInWithCredential(credential);

  //     UserModel userModel;
  //     // log(userCredential.additionalUserInfo.toString());
  //     if (userCredential.additionalUserInfo!.isNewUser) {
  //       userModel = UserModel(
  //         oid: '',
  //         phoneNo: 'xyz',
  //         lastSignInTime: DateTime(00),
  //         name: userCredential.user!.displayName ?? "no name",
  //         email: userCredential.user!.email ?? "notfound@email.com",
  //         profilePic: userCredential.user!.photoURL ?? 'assets/defaultUser.jpg',
  //         uid: userCredential.user!.uid,
  //         rollNO: "rollno",
  //       );
  //       // print(userCredential.user!.email.toString());
  //       await _users.doc(userCredential.user!.uid).set(userModel.toMap());
  //     } else {
  //       // userModel = await getUserData(userCredential.user!.uid).first;
  //     }
  //     // return right(userModel!);
  //   } on FirebaseException catch (e) {
  //     return left(Failure(e.message.toString()));
  //   } catch (e) {
  //     return left(Failure(e.toString()));
  //   }
  // }

  Future<MsUserModel> getCurrentUserDataFromMs(String accessToken) async {
    final response = await http.get(
      Uri.parse('https://graph.microsoft.com/v1.0/me'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );
    // log(response.body);
    // Decode the JSON response.
    final user = MsUserModel.fromJson(response.body);
    return user;
  }

  Future<Stream<MsUserModel>> signIn(
    MsUserModel userModel,
    String accessToken,
  ) async {
    final snap = await _users.doc(userModel.id).get();
    // log('snap ' + snap.toString());
    if (!snap.exists) {
      String photoUrl = dotenv.env['PROFILE_ICON_URL']!;
      final response = await http.get(
        Uri.parse('https://graph.microsoft.com/v1.0/me/photo/\$value'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final file = await createTempFileFromPostRequestBody(response);
        // log(file.path);
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profilePictures/${userModel.id}');

        try {
          //Store the file
          await storageRef.putFile(File(file.path));
          //Success: get the download URL
          photoUrl = await storageRef.getDownloadURL();
        } catch (error) {
          // log(error.toString());
        }
      }
      // log(userModel.jobTitle ?? 'not student');
      List<String>? roles = ['everyone'];
      if (userModel.jobTitle != null && userModel.jobTitle == "Student") {
        roles.add(userModel.jobTitle!);
        String branchCode = userModel.userPrincipalName.substring(6, 8);
        String batch = '${userModel.userPrincipalName.substring(0, 2)}Batch';
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
      // log(userModel.displayName.substring(6, 8));
      await _users.doc(userModel.id).set(userModel
          .copyWith(displayName: '', photo: photoUrl, roles: roles)
          .toMap());
    }
    return getMsUserData(userModel.id);
  }

  void setDisplayName(UserModel userModel, String name) async {
    await _users
        .doc(userModel.uid)
        .set(userModel.copyWith(displayName: name).toMap());
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

  Stream<UserModel?> getUserData(String uid) {
    return _users.doc(uid).snapshots().map((event) {
      return UserModel.fromMap(event.data() as Map<String, dynamic>);
    });
  }

  Future<Stream<UserModel>?> getCurrentUserData(String uid) async {
    final u = await _users.doc(uid).get();
    if (u.exists) {
      return _users.doc(uid).snapshots().map((event) {
        return UserModel.fromMap(event.data() as Map<String, dynamic>);
      });
    }
    return null;
  }

  Future<void> logOut(WidgetRef ref) async {
    // if (ref.watch(userProvider) == null) {
    //   await ref.watch(discordServiceProvider).sendMessage(
    //       ":red_square: **`${_auth.currentUser!.uid}`** `Account Not Found logged out`");
    // } else {
    //   await ref.watch(discordServiceProvider).sendMessage(
    //       ":red_square: **`${ref.watch(userProvider)!.rollNO}`** `logged out`");
    // }

    ref.watch(userProvider.notifier).update((state) => null);
    ref.watch(attendanceProvider.notifier).update((state) => null);
    ref.watch(bioProvider.notifier).update((state) => null);
    // log(ref.watch(userProvider).toString() + "signing out");
    await _auth.signOut();
    // await _aadOAuth.logout();
    // await _googleSignIn.signOut();
  }
}
