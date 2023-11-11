import 'dart:developer';

import 'package:aad_oauth/aad_oauth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:one/core/models/ms_user_model.dart';
import 'package:one/core/models/user_model.dart';
import 'package:one/core/utils.dart';
import 'package:one/features/auth/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/main.dart';
import 'package:one/router.dart';

final userProvider = StateProvider<MsUserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
    aadOAuth: aadOAuth,
  ),
);

final authStateChangeProvider = StreamProvider((ref) {
  return ref.watch(userProvider.notifier).stream;
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
  final AadOAuth _aadOAuth;
  final Ref _ref;
  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
    required AadOAuth aadOAuth,
  })  : _authRepository = authRepository,
        _ref = ref,
        _aadOAuth = aadOAuth,
        super(false); // loading

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signInWithMicrosoft(BuildContext context) async {
    state = true;
    final user = await _aadOAuth.login();
    // state = false;
    user.fold(
      (l) {
        print(l.message);
        showSnackBar(context, l.message);
      },
      (token) async {
        log('sign in');
        final userModel = await _authRepository
            .getCurrentUserDataFromMs(token.accessToken.toString());
        log(token.accessToken.toString());
        await _authRepository.signIn(userModel, token.accessToken!);
        final MsUserModel user =
            await _authRepository.getMsUserData(userModel.id).first;
        _ref.read(userProvider.notifier).update((state) => user);
        _ref.read(RouteProvider.notifier).setRoute(loggedInRoute);
        print(user);
        if (user.roles != null) {
          for (String topic in user.roles!) {
            FirebaseMessaging.instance.subscribeToTopic(topic);
          }
        }

        loginStatus = true;
      },
    );
    state = false;
  }

  Future<MsUserModel> getCurrentUserDataFromMs(String accessToken) async {
    return _authRepository.getCurrentUserDataFromMs(accessToken);
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  Stream<MsUserModel> getMsUserData(String uid) {
    return _authRepository.getMsUserData(uid);
  }

  void logout() async {
    _authRepository.logOut();
    // _ref.read(userProvider.notifier).update((state) => null);
  }
}
