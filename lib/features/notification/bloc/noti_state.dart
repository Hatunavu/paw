import 'package:equatable/equatable.dart';

class NotiState extends Equatable {
  @override
  List<Object> get props => [];
}

class NotiStateInitial extends NotiState {}

class NotiStateLoading extends NotiState {}

class NotiStateFailure extends NotiState {}

class NotiStateSuccess extends NotiState {
  final List notificationn;
  final bool hasReachedEnd;
  final List docs;
  NotiStateSuccess({this.notificationn, this.hasReachedEnd, this.docs});
  @override
  List<Object> get props => [notificationn, hasReachedEnd, docs];
  NotiStateSuccess cloneWith(
      {List notificationn, bool hasReachedEnd, List docs}) {
    return NotiStateSuccess(
        notificationn: notificationn ?? this.notificationn,
        hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
        docs: docs ?? this.docs);
  }
}
