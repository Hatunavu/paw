import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_git/data/model/notificationn.dart';
import 'package:demo_git/shared/extension/noti_type.dart';
import 'package:demo_git/shared/res/colors.dart';
import 'package:demo_git/shared/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:demo_git/shared/extension/difference_time.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotiCardWidget extends StatelessWidget {
  final Notificationn notificationn;
  const NotiCardWidget({Key key, @required this.notificationn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations text = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: notificationn.read
            ? backgroundLogin
            : primaryColor.withOpacity(0.2),
      ),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 5),
      child: ListTile(
        contentPadding: const EdgeInsets.only(right: 8, left: 10),
        horizontalTitleGap: 10,
        leading: Avatar(
          margin: 0,
          size: 40,
          imageUrl: notificationn?.userPush?.avatar,
        ),
        title: RichText(
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(children: [
            TextSpan(
                text: '${notificationn?.userPush?.petName} ',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 13)),
            TextSpan(
                text: notificationn?.type == NotiType.comment.type
                    ? '${text.commented_on_your_post}: ${notificationn.comment}'
                    : notificationn?.type == NotiType.like.type
                        ? text.liked_your_post
                        : text.started_following_you,
                style: const TextStyle(color: Colors.black, fontSize: 13))
          ]),
        ),
        subtitle: Text(
          DifferenceTime(notificationn.createdAt).parseString(text),
          style: const TextStyle(fontSize: 11),
        ),
        trailing: notificationn?.type == NotiType.comment.type ||
                notificationn?.type == NotiType.like.type
            ? Container(
                height: 60,
                width: 60,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        child: Container(
                            height: 60, width: 60, color: backgroundLogin),
                      ),
                      imageUrl: notificationn?.image,
                      fit: BoxFit.cover,
                    )),
              )
            : null,
      ),
    );
  }
}
