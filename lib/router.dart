import 'package:flutter/material.dart';
import 'package:one/features/auth/screens/login_page.dart';
import 'package:one/features/home/screens/home_page.dart';
import 'package:one/features/posts/screens/post_page.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginPage()),
});
final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomePage()),
  '/create-post': (_) => const MaterialPage(child: CreatePostPage()),
});
