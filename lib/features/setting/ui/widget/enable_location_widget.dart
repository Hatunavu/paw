import 'package:demo_git/features/setting/bloc/location_setting_cubit.dart';
import 'package:demo_git/features/setting/bloc/location_setting_state.dart';
import 'package:demo_git/shared/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/src/provider.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EnableLocationWidget extends StatefulWidget {
  const EnableLocationWidget({Key key}) : super(key: key);

  @override
  _EnableLocationWidgetState createState() => _EnableLocationWidgetState();
}

class _EnableLocationWidgetState extends State<EnableLocationWidget> {
  LocationSettingCubit _locationSettingCubit;
  @override
  initState() {
    super.initState();
    _locationSettingCubit = context.read<LocationSettingCubit>();
    _locationSettingCubit.isEnbaleLocation();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    return Container(
      height: 30,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 15, left: 10),
                child: Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Colors.black,
                ),
              ),
              Text(
                text.enable_around,
                style:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
          BlocBuilder<LocationSettingCubit, LocationSettingState>(
              builder: (context, locationState) {
            if (locationState is LocationSettingStateLoading) {
              return Container(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ));
            } else if (locationState is LocationSettingStateFailure) {
              return const SwitchLocation();
            } else if (locationState is LocationSettingStateSuccess) {
              return FlutterSwitch(
                width: 40.0,
                height: 20.0,
                activeColor: primaryColor,
                toggleSize: 15.0,
                value: locationState.enableLocation,
                onToggle: (val) {
                  locationState.enableLocation
                      ? _locationSettingCubit.disableLocation()
                      : _locationSettingCubit.enableLocation();
                },
              );
            }
            return const SwitchLocation();
          })
        ],
      ),
    );
  }
}

class SwitchLocation extends StatelessWidget {
  const SwitchLocation({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      width: 40.0,
      height: 20.0,
      activeColor: primaryColor,
      toggleSize: 15.0,
      value: false,
      onToggle: (bool value) {},
    );
  }
}
