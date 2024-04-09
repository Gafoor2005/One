import 'dart:developer';

// import 'package:aad_oauth/aad_oauth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:one/bot.dart';
import 'package:one/core/models/ms_user_model.dart';
import 'package:one/core/models/user_model.dart';
import 'package:one/core/utils.dart';
import 'package:one/features/auth/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/main.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
    // aadOAuth: aadOAuth,
  ),
);

final authStateChangeProvider = StreamProvider((ref) {
  return ref.watch(authControllerProvider.notifier).authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});
final getMsUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getMsUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
    // required AadOAuth aadOAuth,
  })  : _authRepository = authRepository,
        _ref = ref,
        super(false); // loading

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signInWithMS(BuildContext context) async {
    state = true; // started loader

    final result = await _authRepository.signInWithMS();
    result.fold(
      (l) {
        log(l.message);
        showSnackBar(context, l.message);
        state = false;
      },
      (user) async {
        await _ref
            .watch(discordServiceProvider)
            .sendMessage(":lock: **`${user.rollNO}`** `signed in`");
        _ref.read(userProvider.notifier).update((state) => user);
        // log("from controller ${user.toString()}");
        // if (user.roles != null) {
        //   for (String topic in user.roles!) {
        //     FirebaseMessaging.instance.subscribeToTopic(topic);
        //   }
        // }
        loginStatus = true;
        state = false; // stopped loader
      },
    );
  }

  void setDisplayName(String name) {
    UserModel userModel = _ref.watch(userProvider)!;
    _authRepository.setDisplayName(userModel, name);
    _ref
        .watch(userProvider.notifier)
        .update((state) => userModel.copyWith(displayName: name));
  }

  Future<MsUserModel> getCurrentUserDataFromMs(String accessToken) async {
    return _authRepository.getCurrentUserDataFromMs(accessToken);
  }

  Stream<UserModel?> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  Stream<MsUserModel> getMsUserData(String uid) {
    return _authRepository.getMsUserData(uid);
  }

  Future<void> logout(WidgetRef ref) async {
    _authRepository.logOut(ref);
  }
}
