import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vireo/core/theme/vireo_colors.dart';

class OutdoorMapView extends StatelessWidget {
  const OutdoorMapView({
    super.key,
    required this.route,
    this.followLatest = false,
  });

  final List<LatLng> route;
  final bool followLatest;

  @override
  Widget build(BuildContext context) {
    final colors = context.vireoColors;
    final center = route.isNotEmpty ? route.last : const LatLng(30.0444, 31.2357);

    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: 16,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.vireo',
        ),
        if (route.length >= 2)
          PolylineLayer(
            polylines: [
              Polyline(
                points: route,
                strokeWidth: 5,
                color: colors.ember,
              ),
            ],
          ),
        if (route.isNotEmpty)
          MarkerLayer(
            markers: [
              Marker(
                point: route.first,
                width: 16,
                height: 16,
                child: Icon(Icons.trip_origin, color: colors.success, size: 16),
              ),
              Marker(
                point: route.last,
                width: 20,
                height: 20,
                child: Icon(Icons.navigation_rounded, color: colors.ember, size: 20),
              ),
            ],
          ),
      ],
    );
  }
}
