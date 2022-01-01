import 'dart:async';
import 'dart:ui';

import 'package:demo_git/data/model/location.dart';
import 'package:demo_git/features/around/bloc/around_cubit.dart';
import 'package:demo_git/features/around/bloc/around_state.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:demo_git/shared/res/colors.dart';
import 'package:demo_git/shared/routers/router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/src/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

class AroundPage extends StatefulWidget {
  const AroundPage({Key key}) : super(key: key);

  @override
  _AroundPageState createState() => _AroundPageState();
}

class _AroundPageState extends State<AroundPage> {
  AroundCubit _aroundCubit;
  UserRepository _userRepository;
  ClusterManager _manager;
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = Set();
  List<Locationn> locations = [];
  ui.Image image;

  ClusterManager _initClusterManager() {
    return ClusterManager<Locationn>(locations, _updateMarkers,
        markerBuilder: _markerBuilder(context, _userRepository),
        stopClusteringZoom: 17);
  }

  void _updateMarkers(Set<Marker> markers) {
    print('Updated ${markers.length} markers');
    setState(() {
      this.markers = markers;
    });
  }

  @override
  void initState() {
    super.initState();
    _aroundCubit = context.read<AroundCubit>();
    _userRepository = context.read<UserRepositoryImplement>();
    _aroundCubit.getLocation();
    _manager = _initClusterManager();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: AppBar(
            elevation: 0.3,
            backgroundColor: primaryColor.withOpacity(0.5),
            title: Text(text.around),
            centerTitle: true,
            automaticallyImplyLeading: false,
            leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
        ),
        body: BlocBuilder<AroundCubit, AroundState>(
            builder: (context, aroundState) {
          if (aroundState is AroundStateFailure) {
            Navigator.pop(context);
          } else if (aroundState is AroundStateSuccess) {
            final Locationn currentLocation = aroundState.currentLocation;
            locations = aroundState.locations;
            return GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                    target: LatLng(
                      currentLocation.latitude,
                      currentLocation.longitude,
                    ),
                    zoom: 15),
                markers: markers,
                myLocationEnabled: true,
                onMapCreated: (GoogleMapController controller) {
                  _manager = _initClusterManager();
                  _controller.complete(controller);
                  _manager.setMapId(controller.mapId);
                },
                onCameraMove: _manager.onCameraMove,
                onCameraIdle: _manager.updateMap);
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }));
  }
}

Future<Marker> Function(Cluster<Locationn>) _markerBuilder(
        BuildContext context, UserRepository _userRepository) =>
    (cluster) async {
      return Marker(
          markerId: MarkerId(cluster.getId()),
          position: cluster.location,
          infoWindow: cluster.count == 1
              ? InfoWindow(
                  title: cluster.items.first.user.petName,
                  onTap: () {
                    AppRouter.routeToProfile(
                        context: context,
                        userRepository: _userRepository,
                        uid: cluster.items.first.user.uid,
                        isBack: true);
                  })
              : InfoWindow.noText,
          icon: await getMarkerIcon(
              cluster.items.first.user.avatar, const Size(150.0, 150.0),
              text: cluster.isMultiple ? cluster.count.toString() : null));
    };

Future<ui.Image> getImage(String path) async {
  final Completer<ImageInfo> completer = Completer();
  final img = NetworkImage(path);
  img
      .resolve(const ImageConfiguration())
      .addListener(ImageStreamListener((ImageInfo info, bool _) {
    completer.complete(info);
  }));
  final ImageInfo imageInfo = await completer.future;
  return imageInfo.image;
}

Future<BitmapDescriptor> getMarkerIcon(String imagePath, Size size,
    {String text}) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);

  final Radius radius = Radius.circular(size.width / 2);

  final Paint tagPaint = Paint()..color = primaryColor;
  const double tagWidth = 40.0;

  final Paint shadowPaint = Paint()..color = primaryColor.withAlpha(100);
  const double shadowWidth = 15.0;

  final Paint borderPaint = Paint()..color = Colors.white;
  const double borderWidth = 3.0;

  const double imageOffset = shadowWidth + borderWidth;
  canvas
    ..drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, size.width, size.height),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        shadowPaint)
    ..drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(shadowWidth, shadowWidth,
              size.width - (shadowWidth * 2), size.height - (shadowWidth * 2)),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        borderPaint);
  if (text != null) {
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(size.width - tagWidth, 0.0, tagWidth, tagWidth),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        tagPaint);
    final TextPainter textPainter =
        TextPainter(textDirection: TextDirection.ltr);
    textPainter
      ..text = TextSpan(
        text: text,
        style: const TextStyle(fontSize: 20.0, color: Colors.white),
      )
      ..layout()
      ..paint(
          canvas,
          Offset(size.width - tagWidth / 2 - textPainter.width / 2,
              tagWidth / 2 - textPainter.height / 2));
  }
  final Rect oval = Rect.fromLTWH(imageOffset, imageOffset,
      size.width - (imageOffset * 2), size.height - (imageOffset * 2));
  canvas.clipPath(Path()..addOval(oval));
  final ui.Image image = await getImage(imagePath);
  paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.cover);
  final ui.Image markerAsImage = await pictureRecorder
      .endRecording()
      .toImage(size.width.toInt(), size.height.toInt());
  final ByteData byteData =
      await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List uint8List = byteData.buffer.asUint8List();
  return BitmapDescriptor.fromBytes(uint8List);
}
