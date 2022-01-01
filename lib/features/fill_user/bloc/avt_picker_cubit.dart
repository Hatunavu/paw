import 'dart:io';

import 'package:demo_git/features/fill_user/bloc/avt_picker_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AvtPickerCubit extends Cubit<AvtPickerState> {
  AvtPickerCubit() : super(AvtPickerState(null));
  Future openGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      emit(AvtPickerState(File(image.path)));
    } catch (e) {
      throw Exception('Error');
    }
  }

  Future openCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      emit(AvtPickerState(File(image.path)));
    } catch (e) {
      throw Exception('Error');
    }
  }
}
