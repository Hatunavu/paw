import 'package:demo_git/data/model/notificationn.dart';
import 'package:demo_git/features/notification/bloc/noti_state.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotiCubit extends Cubit<NotiState> {
  final UserRepository _userRepository;

  NotiCubit(this._userRepository) : super(NotiStateInitial());
  Future<void> getNoti() async {
    try {
      if (!((state is NotiStateSuccess) &&
          (state as NotiStateSuccess).hasReachedEnd)) {
        if (state is NotiStateInitial) {
          List notificationn;
          await _userRepository
              .getNoti()
              .then((value) => value.listen((snapshot) {
                    notificationn = snapshot.docs
                        .map((doc) => Notificationn.fromJson(doc))
                        .toList();
                    emit(NotiStateSuccess(
                        notificationn: notificationn,
                        hasReachedEnd: false,
                        docs: snapshot.docs));
                  }));
        } else if (state is NotiStateSuccess) {
          List notificationn;
          List docs;
          final currentState = state as NotiStateSuccess;
          await _userRepository
              .getNextNoti(currentState.docs)
              .then((value) => value.listen((snapshot) {
                    docs = snapshot.docs;
                    notificationn = snapshot.docs
                        .map((doc) => Notificationn.fromJson(doc))
                        .toList();
                    if (notificationn.isEmpty) {
                      emit(currentState.cloneWith(hasReachedEnd: true));
                    } else {
                      emit(NotiStateSuccess(
                          notificationn:
                              currentState.notificationn + notificationn,
                          hasReachedEnd: false,
                          docs: currentState.docs + docs));
                    }
                  }));
        }
      }
    } catch (e) {
      emit(NotiStateFailure());
    }
  }

  void readFollow({@required String id}) {
    _userRepository.readNotification(id: id);
  }
}
