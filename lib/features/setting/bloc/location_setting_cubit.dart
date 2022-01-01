import 'package:demo_git/data/model/base_user.dart';
import 'package:demo_git/data/model/location.dart';
import 'package:demo_git/data/model/userr.dart';
import 'package:demo_git/features/setting/bloc/location_setting_state.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class LocationSettingCubit extends Cubit<LocationSettingState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserRepository userRepository;
  LocationSettingCubit({@required this.userRepository})
      : super(LocationSettingStateInitial());
  Future<void> enableLocation() async {
    emit(LocationSettingStateLoading());
    try {
      final Userr userr =
          await userRepository.getUserr(_firebaseAuth.currentUser.uid);
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      await userRepository.enableLocation(
          locationn: Locationn(
              longitude: position.longitude,
              latitude: position.latitude,
              user: BaseUser(
                  uid: userr.uid,
                  avatar: userr.avatar,
                  petName: userr.petName)));
    } catch (e) {
      emit(LocationSettingStateFailure());
    }
  }

  Future<void> disableLocation() async {
    await userRepository.disableLocation();
  }

  void isEnbaleLocation() {
    bool isEnable = false;
    userRepository.getLocation().then((value) => value.listen((snapshot) {
          if (snapshot.docs == null || snapshot.docs.isEmpty) {
            isEnable = false;
          } else {
            for (final location in snapshot.docs) {
              if (location?.id == _firebaseAuth.currentUser.uid) {
                isEnable = true;
                break;
              } else {
                isEnable = false;
              }
            }
          }
          emit(LocationSettingStateSuccess(enableLocation: isEnable));
        }));
  }
}
