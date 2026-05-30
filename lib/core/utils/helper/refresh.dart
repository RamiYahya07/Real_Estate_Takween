import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RefreshWidget extends StatelessWidget {
  const RefreshWidget({
    super.key,
    required this.child,
    required this.onRefresh,
    required this.keyRefresh,
  });
  final Widget child;
  final Future Function() onRefresh;
  final GlobalKey<RefreshIndicatorState> keyRefresh;
  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid ? buildAndroidWidget() : buildIosWidget();
  }

  Widget buildIosWidget() {
    return CustomScrollView(
      slivers: [
        CupertinoSliverRefreshControl(onRefresh: onRefresh, key: keyRefresh),
        SliverToBoxAdapter(child: child),
      ],
    );
  }

  Widget buildAndroidWidget() {
    return RefreshIndicator(
      key: keyRefresh,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
