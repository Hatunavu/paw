import 'package:demo_git/features/fill_user/bloc/gender_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenderCubit extends Cubit<GenderState> {
  GenderCubit() : super(GenderState(null));
  Future<void> updateGender(int gender) async {
    emit(GenderState(gender));
  }
}
