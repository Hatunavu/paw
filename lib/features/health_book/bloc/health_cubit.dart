import 'package:demo_git/data/model/health_book.dart';
import 'package:demo_git/features/health_book/bloc/health_state.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HealthCubit extends Cubit<HealthState> {
  UserRepository _userRepository;
  HealthCubit(this._userRepository) : super(HealthStateInitial());

  Future<void> getHealth() async {
    try {
      if (!((state is HealthStateSuccess) &&
          (state as HealthStateSuccess).hasReachedEnd)) {
        if (state is HealthStateInitial) {
          List healthBooks;
          await _userRepository
              .getHealth()
              .then((value) => value.listen((snapshot) {
                    healthBooks = snapshot.docs
                        .map((doc) => HealthBook.fromDoc(doc))
                        .toList();
                    emit(HealthStateSuccess(
                        healthBooks: healthBooks,
                        hasReachedEnd: false,
                        docs: snapshot.docs));
                  }));
        } else if (state is HealthStateSuccess) {
          List healthBooks;
          List docs;
          final currentState = state as HealthStateSuccess;
          await _userRepository
              .getNextHealth(currentState.docs)
              .then((value) => value.listen((snapshot) {
                    docs = snapshot.docs;
                    healthBooks = snapshot.docs
                        .map((doc) => HealthBook.fromDoc(doc))
                        .toList();
                    if (healthBooks.isEmpty) {
                      emit(currentState.cloneWith(hasReachedEnd: true));
                    } else {
                      emit(HealthStateSuccess(
                          healthBooks: currentState.healthBooks + healthBooks,
                          hasReachedEnd: false,
                          docs: currentState.docs + docs));
                    }
                  }));
        }
      }
    } catch (e) {
      emit(HealthStateFailure());
    }
  }
}
