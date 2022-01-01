import 'package:demo_git/data/model/health_book.dart';
import 'package:equatable/equatable.dart';

class HealthState extends Equatable {
  @override
  List<Object> get props => [];
}

class HealthStateInitial extends HealthState {}

class HealthStateLoading extends HealthState {}

class HealthStateSuccess extends HealthState {
  final List<HealthBook> healthBooks;
  final bool hasReachedEnd;
  final List docs;
  HealthStateSuccess({this.healthBooks, this.hasReachedEnd, this.docs});
  @override
  List<Object> get props => [healthBooks, hasReachedEnd, docs];
  HealthStateSuccess cloneWith(
      {List healthBooks, bool hasReachedEnd, List docs}) {
    return HealthStateSuccess(
        healthBooks: healthBooks ?? this.healthBooks,
        hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
        docs: docs ?? this.docs);
  }
}

class HealthStateFailure extends HealthState {}
