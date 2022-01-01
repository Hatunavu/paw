import 'package:demo_git/features/post/bloc/location_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationStateInitial());
  Future<void> getLocation() async {
    emit(LocationStateLoading());
    final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final List<Placemark> placeMarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    final Placemark placemark = placeMarks[0];
    final String formattedAddress =
        '${placemark.name}, ${placemark.administrativeArea}';
    emit(LocationStateSuccess(formattedAddress));
  }
}
