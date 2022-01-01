import 'package:demo_git/features/health_book/bloc/done_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoneCubit extends Cubit<DoneState> {
  DoneCubit() : super(DoneState(false));
  Future<void> updateDone(bool done) async {
    emit(DoneState(done));
  }
}
