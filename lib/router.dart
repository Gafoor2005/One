import 'package:flutter/material.dart';
import 'package:one/features/auth/screens/login_page.dart';
import 'package:one/features/home/screens/home_page.dart';
import 'package:one/features/posts/screens/post_details.dart';
import 'package:one/features/posts/screens/post_page.dart';
import 'package:one/notif.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginPage()),
  '/notif': (r) => const MaterialPage(child: Notif()),
});
final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomePage()),
  '/create-post': (_) => const MaterialPage(child: CreatePostPage()),
  '/notif': (_) => const MaterialPage(child: Notif()),
  '/post/:id': (info) => MaterialPage(
        child: PostDetails(
          id: info.pathParameters['id']!,
        ),
      ),
});
