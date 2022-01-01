import 'package:demo_git/data/model/userr.dart';
import 'package:demo_git/features/profile/bloc/follow_cubit.dart';
import 'package:demo_git/features/profile/bloc/follow_state.dart';
import 'package:demo_git/shared/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FollowButton extends StatelessWidget {
  final FollowCubit followCubit;
  final String uid;
  final Userr userr;
  const FollowButton(
      {Key key,
      @required this.followCubit,
      @required this.uid,
      @required this.userr})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: BlocBuilder<FollowCubit, FollowState>(
        builder: (context, followState) {
          if (followState is FollowStateSuccess) {
            return Center(
                child: InkWell(
              onTap: () {
                followState.isFollowing
                    ? followCubit.unFollow(uid: uid, userrFollowing: userr)
                    : followCubit.follow(uid: uid, userrFollowing: userr);
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                    border: Border.all(color: primaryColor),
                    color:
                        followState.isFollowing ? Colors.white : primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  followState.isFollowing ? text.following : text.follow,
                  style: TextStyle(
                      color:
                          followState.isFollowing ? primaryColor : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
                ),
              ),
            ));
          }
          return Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                text.follow,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
            ),
          );
        },
      ),
    );
  }
}
