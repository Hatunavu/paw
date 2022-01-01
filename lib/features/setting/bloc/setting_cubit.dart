import 'package:demo_git/features/setting/bloc/setting_state.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class SettingCubit extends Cubit<SettingState> {
  final UserRepository _userRepository;
  SettingCubit(this._userRepository) : super(SettingStateInitial());

  Future<void> getLang() async {
    await _userRepository.getLang();
  }

  Future<void> setLang(String lang) async {
    await _userRepository.setLang(lang);
  }

  Future<void> enableLocation() async {
    final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }
}
