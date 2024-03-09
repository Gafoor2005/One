import 'package:flutter/material.dart';
import 'package:one/features/auth/screens/login_page.dart';
import 'package:one/features/auth/screens/need_more_info.dart';
import 'package:one/features/home/screens/add_news.dart';
import 'package:one/features/home/screens/chat_page.dart';
import 'package:one/features/home/screens/home_frame.dart';
import 'package:one/features/home/screens/set_displayname.dart';
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
  '/': (_) => const MaterialPage(child: LoginPage()),
  '/more-info': (_) => const MaterialPage(child: NeedMoreInfo()),
  '/notif': (r) => const MaterialPage(child: Notif()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeFrame()),
  '/set-displayname': (_) => const MaterialPage(child: SetDisplayName()),
  '/demo': (_) => const MaterialPage(child: DemoPage()),
  '/attendance': (_) => const MaterialPage(child: AttendancePage()),
  '/bio': (_) => const MaterialPage(child: BioPage()),
  '/upload-file': (_) => const MaterialPage(child: UploadFile()),
  '/create-post': (_) => const MaterialPage(child: CreatePostPage()),
  '/notif': (_) => const MaterialPage(child: Notif()),
  '/add-news': (_) => const MaterialPage(child: AddNews()),
  '/post/:id': (info) => MaterialPage(
        child: PostDetails(
          id: info.pathParameters['id']!,
        ),
      ),
});
