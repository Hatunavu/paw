import 'dart:io';

import 'package:equatable/equatable.dart';

class AvtPickerState extends Equatable {
  File imagePicked;
  AvtPickerState(this.imagePicked);
  @override
  List<Object> get props => [imagePicked];
}
