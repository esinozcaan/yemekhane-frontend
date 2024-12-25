import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yemekhane_app/core/models/upload_media_result.dart';
import 'package:yemekhane_app/views/detail_screen.dart';
import 'package:yemekhane_app/views/take_photo_screen.dart';

import '../views/home_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'homePage',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/takePhoto',
      name: 'takePhoto',
      builder: (context, state) => const TakePhotoScreen(),
    ),
    GoRoute(
      path: '/detail',
      name: 'detail',
      builder: (context, state) {
        // Ensure `state.extra` is a `ResponseModel` instance
        final result = state.extra as ResponseModel?;
        if (result == null) {
          return const Center(
            child: Text('No data available.'),
          );
        }
        return DetailScreen(result: result);
      },
    ),
  ],
);
