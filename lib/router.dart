import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:one/features/auth/controller/auth_controller.dart';
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
import 'package:one/features/settings/screens/account_page.dart';

final waitingRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: ChatPage()),
});
final loggedOutRoute = RouteMap(routes: {
  '/create-form': (info) => const MaterialPage(
        child: LoginPage(),
      ),
  '/form/:id': (info) => const MaterialPage(
        child: LoginPage(),
      ),
  '/accounts': (_) => const Redirect('/'),
  '/more-info': (_) => const MaterialPage(child: NeedMoreInfo()),
  // '/notif': (r) => const MaterialPage(child: Notif()),
  '/': (_) => const MaterialPage(child: LoginPage()),
});

class LoggedInRoutes {
  final Ref myref;

  LoggedInRoutes({required this.myref});

  bool canAccessFormPage(String path) {
    if (myref.watch(userProvider)!.out != null) {
      print(path);
    }
    return false;
  }

  RouteMap routeMap = RouteMap(routes: {
    '/create-form': (_) => const MaterialPage(child: CreateFormPage()),
    // '/form/:id/:d':
    '/form/:id': (info) {
      return MaterialPage(
        child: FormPage(
          formId: info.pathParameters['id']!,
        ),
      );
    },
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
    '/accounts': (_) => const MaterialPage(child: AccountPage()),
    '/post/:id': (info) => MaterialPage(
          child: PostDetails(
            id: info.pathParameters['id']!,
          ),
        ),
    '/': (_) => const MaterialPage(child: HomeFrame()),
  });
}

final loggedInRoute = RouteMap(routes: {
  '/create-form': (_) => const MaterialPage(child: CreateFormPage()),
  // '/form/:id/:d': ()
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
  '/accounts': (_) => const MaterialPage(child: AccountPage()),
  '/post/:id': (info) => MaterialPage(
        child: PostDetails(
          id: info.pathParameters['id']!,
        ),
      ),
  '/': (_) => const MaterialPage(child: HomeFrame()),
});
