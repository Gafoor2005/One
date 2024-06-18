import 'package:flutter/material.dart';
import 'package:one/features/auth/screens/login_page.dart';
import 'package:one/features/auth/screens/need_more_info.dart';
import 'package:one/features/home/screens/add_news.dart';
import 'package:one/features/home/screens/chat_page.dart';
import 'package:one/features/home/screens/create_elective.dart';
import 'package:one/features/home/screens/create_form.dart';
import 'package:one/features/home/screens/create_regulation.dart';
import 'package:one/features/home/screens/create_subject.dart';
import 'package:one/features/home/screens/electives_page.dart';
import 'package:one/features/home/screens/form_page.dart';
import 'package:one/features/home/screens/home_frame.dart';
import 'package:one/features/home/screens/regulation.dart';
import 'package:one/features/home/screens/set_displayname.dart';
import 'package:one/features/home/screens/set_pass.dart';
import 'package:one/features/home/screens/subjects_page.dart';
import 'package:one/features/posts/screens/post_details.dart';
import 'package:one/features/posts/screens/post_page.dart';
import 'package:one/features/posts/screens/upload_file.dart';
import 'package:one/features/settings/screens/attendance_page.dart';
import 'package:one/features/settings/screens/bio_page.dart';
import 'package:one/notif.dart';
import 'package:one/offline_test.dart';
import 'package:routemaster/routemaster.dart';

final waitingRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: ChatPage()),
});
final loggedOutRoute = RouteMap(routes: {
  '/more-info': (_) => const MaterialPage(child: NeedMoreInfo()),
  // '/notif': (r) => const MaterialPage(child: Notif()),
  '/': (_) => const MaterialPage(child: LoginPage()),
});

final loggedInRoute = RouteMap(routes: {
  '/create-form': (_) => const MaterialPage(child: CreateFormPage()),
  '/form/:id': (info) => MaterialPage(
        child: FormPage(
          formId: info.pathParameters['id']!,
        ),
      ),
  '/regulations/:id/:eid/create': (info) => MaterialPage(
        child: CreateSubjectPage(
          regulationId: info.pathParameters['id']!,
          electiveId: info.pathParameters['eid']!,
        ),
      ),
  '/regulations/:id/:eid': (info) => MaterialPage(
        child: SubjectsPage(
          regulationId: info.pathParameters['id']!,
          electiveId: info.pathParameters['eid']!,
        ),
      ),
  '/regulations/:id/create-elective': (info) => MaterialPage(
        child: CreateElectivePage(
          regulaitonId: info.pathParameters['id']!,
        ),
      ),
  '/regulations/:id': (info) => MaterialPage(
        child: ElectivesPage(
          regulationId: info.pathParameters['id']!,
        ),
      ),
  '/regulations/create-regulation': (_) =>
      const MaterialPage(child: CreateRegulation()),
  '/set-pass': (_) => const MaterialPage(child: SetPassword()),
  '/regulations': (_) => const MaterialPage(child: RegulationsPage()),
  '/set-displayname': (_) => const MaterialPage(child: SetDisplayName()),
  '/demo': (_) => const MaterialPage(child: DemoPage()),
  '/attendance': (_) => const MaterialPage(child: AttendancePage()),
  '/bio': (_) => const MaterialPage(child: BioPage()),
  '/upload-file': (_) => const MaterialPage(child: UploadFile()),
  '/create-post': (_) => const MaterialPage(child: CreatePostPage()),
  // '/notif': (_) => const MaterialPage(child: Notif()),
  '/add-news': (_) => const MaterialPage(child: AddNews()),
  '/post/:id': (info) => MaterialPage(
        child: PostDetails(
          id: info.pathParameters['id']!,
        ),
      ),
  '/': (_) => const MaterialPage(child: HomeFrame()),
});
