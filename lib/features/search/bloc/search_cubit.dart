import 'package:demo_git/data/model/userr.dart';
import 'package:demo_git/features/search/bloc/search_state.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchCubit extends Cubit<SearchState> {
  UserRepository userRepository;
  List<Userr> resultsList;
  SearchCubit(this.userRepository) : super(SearchStateIntial());
  Future<void> seachUserr(String searchText) async {
    emit(SearchStateLoading());
    await userRepository.getSearchUserr(searchText).then((value) {
      resultsList = value.map((userr) => Userr.fromDoc(userr)).toList();
    });
    emit(SearchStateSuccess(resultsList));
  }
}
