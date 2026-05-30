import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouteTransitions {
  RouteTransitions._();

  static CustomTransitionPage slideTransition({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      transitionDuration: const Duration(milliseconds: 300),
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0), 
            end: Offset.zero,         
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutCubic,
            ),
          ),
          child: child,
        );
      },
    );
  }
}