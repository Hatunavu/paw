import 'package:demo_git/features/fill_user/bloc/date_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DateCubit extends Cubit<DateState> {
  DateCubit() : super(DateState(null));
  Future<void> updateDate(DateTime dateTime) async {
    emit(DateState(dateTime));
  }
}
