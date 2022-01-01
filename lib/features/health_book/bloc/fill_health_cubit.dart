import 'package:demo_git/data/model/health_book.dart';
import 'package:demo_git/features/health_book/bloc/fill_health_state.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FillHealthCubit extends Cubit<FillHealthState> {
  UserRepository _userRepository;
  FillHealthCubit(this._userRepository) : super(FillHealthStateInitial());

  Future<void> fillHealth(
      {@required String id,
      @required String title,
      @required DateTime schedule,
      @required String address,
      @required bool done,
      @required bool isUpdate,
      @required DateTime createdAt}) async {
    emit(FillHealthStateLoading());
    await _userRepository
        .fillHealth(
            healthBook: HealthBook(
                id: id,
                title: title,
                createdAt: createdAt,
                schedule: schedule,
                address: address,
                done: done),
            id: id,
            isUpdate: isUpdate)
        .then((value) => emit(FillHealthStateSuccess()));
  }
}
