import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:takween/Features/maps/data/repos/map_repo.dart';
import 'package:takween/Features/maps/presentation/views/widgets/search_bar.dart';
import 'package:takween/core/di/injection.dart';
import 'package:takween/core/theme/theme_cubit.dart';
import 'package:takween/core/utils/app_strings.dart';
import 'package:takween/core/utils/assets.dart';
import 'package:takween/core/widgets/custom_button.dart';

class GoogleMapFlutter extends StatefulWidget {
  const GoogleMapFlutter({super.key});
  @override
  State<GoogleMapFlutter> createState() => GoogleMapFlutterState();
}

class GoogleMapFlutterState extends State<GoogleMapFlutter> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  final _service = sl<MapRepo>();
  void _handleSelection(String id, String des) async {
    final coords = await _service.getLatLng(id);
    if (coords != null) {
      final pos = LatLng(coords['lat']!, coords['lng']!);
      final controller = await _controller.future;

      controller.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: pos, zoom: 14)),
      );

      setState(() {
        selectedLocation = pos;
        markers = {
          Marker(
            markerId: const MarkerId('selected'),
            position: pos,
            infoWindow: InfoWindow(title: des),
          ),
        };
      });
    }
  }

  String mapStyle = "";
  LatLng? selectedLocation;
  Set<Marker> markers = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadMapStyle();
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.51385039934534, 36.27670495711885),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state == ThemeMode.dark;

    return Scaffold(
      body: FutureBuilder<String?>(
        future: isDark ? _loadMapStyle() : Future.value(null),
        builder: (context, snapshot) {
          if (isDark && !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final style = snapshot.data;

          return Stack(
            children: [
              GoogleMap(
                key: ValueKey(isDark), // 🔥 rebuild when theme changes
                style: style, // null = default light map
                initialCameraPosition: _kGooglePlex,
                markers: markers,
                onMapCreated: (controller) {
                  _controller.complete(controller);
                },
                onTap: (LatLng position) {
                  setState(() {
                    selectedLocation = position;
                    markers = {
                      Marker(
                        markerId: const MarkerId('selected'),
                        position: position,
                      ),
                    };
                  });
                  debugPrint(
                    "Lat: ${position.latitude}, Lng: ${position.longitude}",
                  );
                },
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 16,
                right: 16,
                child: LocationSearchBar(
                  repo: _service,
                  onPlaceSelected: _handleSelection,
                ),
              ),
              if (selectedLocation != null)
                Positioned(
                  bottom: 24,
                  left: 16,
                  right: 16,
                  child: CustomButton(
                    onTap: () => Navigator.pop(context, selectedLocation),
                    title: AppStrings.confirmLocation.tr(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<String> _loadMapStyle() async {
    final style = await DefaultAssetBundle.of(
      context,
    ).loadString(AppAssets.kAubergineMap);

    debugPrint("STYLE LOADED LENGTH: ${style.length}");
    return style;
  }

  // Future<void> _loadMapStyle() async {
  //   final String style = await DefaultAssetBundle.of(
  //     context,
  //   ).loadString(AppAssets.kAubergineMap);
  //   debugPrint("STYLE LOADED LENGTH: ${style.length}");
  //   setState(() {
  //     mapStyle = style;
  //   });
  // }
}



// better to use marker with onCreateMap to create marker when rendering the map




// //change icon of marker
// BitmapDescriptor? customIcon;
// void _loadCustomMarker(String asset) async {
//   customIcon = await BitmapDescriptor.asset(
//     const ImageConfiguration(size: Size(48, 48)),
//   asset,
//   );
// }

 