import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/bot.dart';
import 'package:one/core/utils.dart';
import 'package:one/features/auth/controller/auth_controller.dart';
import 'package:one/features/home/screens/api_repository.dart';
import 'package:one/features/home/screens/bio.dart';
import 'package:one/features/home/screens/home_frame.dart';
import 'package:one/features/settings/screens/attendance_page.dart';
import 'package:routemaster/routemaster.dart';

final bioProvider = StateProvider<Bio?>((ref) => null);
final passProvider = StateProvider<String?>((ref) => null);

final apiControllerProvider = StateNotifierProvider<ApiController, bool>(
  (ref) =>
      ApiController(apiRepository: ref.watch(apiRepositoryProvider), ref: ref),
);

class ApiController extends StateNotifier<bool> {
  final ApiRepository _apiRepository;
  final Ref _ref;

  ApiController({required ApiRepository apiRepository, required Ref ref})
      : _apiRepository = apiRepository,
        _ref = ref,
        super(false); // loading

  Future<void> auth() async {
    log(_ref.watch(passProvider)!);
    Map requestBody = {
      '__VIEWSTATE': dotenv.env['VIEW_STATE'],
      '__VIEWSTATEGENERATOR': dotenv.env['VIEW_STATE_GENERATOR'],
      '__EVENTVALIDATION': dotenv.env['EVENT_VALIDATION'],
      'txtId2': _ref.watch(userProvider)!.rollNO,
      'txtPwd2': _ref.watch(passProvider)!,
      'imgBtn2.x': '44',
      'imgBtn2.y': '10',
    };
    await _apiRepository.postAuth(
      requestBody,
    );
  }

  void getBio(BuildContext context, String roll) async {
    await _ref
        .watch(discordServiceProvider)
        .sendMessage("$roll is fetching bio");
    await auth();
    // state = true;
    final result =
        await _apiRepository.postBio('RollNo=$roll\nisImageDisplay=false');
    result.fold((l) {
      // log(l.message);
      showSnackBar(context, l.message);
      // state = false;
    }, (bio) {
      _ref.read(bioProvider.notifier).update((state) => bio);
      // state = false; // stopped loader
    });
  }

  Future<bool> getAttendance(BuildContext context, String roll) async {
    // log(_ref.watch(settingsProvider)['allow-attendance'].toString());
    if (!(_ref.watch(settingsProvider)['allow-attendance'])) {
      await _ref
          .watch(discordServiceProvider)
          .sendMessage(":calendar_spiral: **`$roll`** `viewing attendence`");
      await auth();
      // state = true;
      final result = await _apiRepository.postAttendance('RollNo=$roll');
      result.fold((l) {
        log(l.message);
        // showSnackBar(context, l.message);
        // state = false;
      }, (att) {
        _ref.read(attendanceProvider.notifier).update((state) => att);
        // state = false; // stopped loader
      });
      return false;
    }
    return true;
  }
}
