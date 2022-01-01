import 'package:demo_git/data/model/location.dart';
import 'package:demo_git/features/around/bloc/around_state.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class AroundCubit extends Cubit<AroundState> {
  UserRepository _userRepository;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AroundCubit(this._userRepository) : super(AroundStateInitial());
  Future<void> getLocation() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      await _userRepository
          .getLocation()
          .then((value) => value.listen((snapshot) {
                Locationn currentLocation;
                final List<Locationn> locations = [];
                snapshot.docs.map((location) {
                  if (location.id == _firebaseAuth.currentUser.uid) {
                    currentLocation = Locationn(
                        longitude: position.longitude,
                        latitude: position.latitude,
                        user: Locationn.fromDoc(location).user);
                  } else {
                    locations.add(Locationn.fromDoc(location));
                  }
                }).toList();
                emit(AroundStateSuccess(
                    locations: locations, currentLocation: currentLocation));
              }));
    } catch (e) {
      emit(AroundStateFailure());
    }
  }
}
