import 'package:equatable/equatable.dart';

class SearchState extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchStateIntial extends SearchState {}

class SearchStateLoading extends SearchState {}

class SearchStateSuccess extends SearchState {
  List resultsList;
  SearchStateSuccess(this.resultsList);
  @override
  List<Object> get props => [resultsList];
}
