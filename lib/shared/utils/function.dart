import 'package:demo_git/features/fill_user/bloc/avt_picker_cubit.dart';
import 'package:demo_git/shared/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<void> pickUpImage(BuildContext context, AvtPickerCubit _avtPickerCubit) {
  final text = AppLocalizations.of(context);
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12))),
          title: Text(text.choose_image,
              style:
                  TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  onTap: () {
                    _avtPickerCubit.openGallery();
                    Navigator.pop(context);
                  },
                  child: Text(text.galery,
                      style: const TextStyle(color: Colors.black54)),
                ),
                const SizedBox(
                  height: 16,
                ),
                GestureDetector(
                  onTap: () {
                    _avtPickerCubit.openCamera();
                    Navigator.pop(context);
                  },
                  child: Text(text.camera,
                      style: const TextStyle(color: Colors.black54)),
                ),
              ],
            ),
          ),
        );
      });
}

unfocus(BuildContext context) {
  FocusScope.of(context).unfocus();
  TextEditingController().clear();
}
