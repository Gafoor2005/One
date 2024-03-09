import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:one/core/failuer.dart';
import 'package:one/core/type_defs.dart';
import 'package:one/features/home/screens/bio.dart';
import 'package:one/features/settings/screens/attendance_page.dart';

final apiRepositoryProvider = Provider((ref) => ApiRepository());

class ApiRepository {
  Map<String, String> headers = {
    'Accept':
        'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7'
  };
  String sessionId = '';
  String frmAuth = '';
  final bioUrl = dotenv.env['BIO_URL']!;
  final authUrl = dotenv.env['AUTH_URL']!;
  final attendanceUrl = dotenv.env['ATTENDANCE_URL']!;
  void updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      List<String> cook = rawCookie.split(' path=/; HttpOnly,');
      if (cook[0].contains('ASP.NET_SessionId=')) {
        sessionId = cook[0];
      }
      if (cook[cook.length - 1].contains('frmAuth=')) {
        frmAuth = cook[cook.length - 1].replaceAll('; path=/', '');
      }
      // log((sessionId + frmAuth));
      headers['cookie'] = (index == -1) ? rawCookie : sessionId + frmAuth;
    }
  }

  Future<String> postAuth(dynamic data) async {
    // log('header before $headers');
    http.Response response =
        await http.post(Uri.parse(authUrl), body: data, headers: headers);
    updateCookie(response);
    // log('header after $headers');
    return response.body;
  }

  FutureEither<Bio> postBio(dynamic data) async {
    Bio bio;
    try {
      http.Response response =
          await http.post(Uri.parse(bioUrl), body: data, headers: headers);
      if (response.statusCode == 200) {
        bio = Bio.response(response.body);
      } else {
        // log('error bio! status code:', error: response.statusCode);
        return left(
            Failure("cannot get bio.\nstatus code:${response.statusCode}"));
      }
      return right(bio);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<AttendanceModel> postAttendance(dynamic data) async {
    AttendanceModel att;
    try {
      http.Response response = await http.post(Uri.parse(attendanceUrl),
          body: data, headers: headers);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        att = AttendanceModel.response(response.body);
      } else {
        // log('error bio! status code:', error: response.statusCode);
        return left(
            Failure("cannot get bio.\nstatus code:${response.statusCode}"));
      }
      return right(att);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
