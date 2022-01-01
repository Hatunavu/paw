import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_git/data/model/comment.dart';
import 'package:demo_git/shared/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:demo_git/shared/extension/difference_time.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommentCardWidget extends StatelessWidget {
  final Comment comment;
  const CommentCardWidget({Key key, @required this.comment}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppLocalizations text = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 10),
                height: 35,
                width: 35,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        child: const CircleAvatar(),
                      ),
                      imageUrl: comment.avatar,
                      fit: BoxFit.cover,
                    )),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comment.petName,
                    style: TextStyle(
                        color: primaryBlack,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    DifferenceTime(comment.createdAt).parseString(text),
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  )
                ],
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 45, right: 20),
            child: Text(
              comment.comment,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}
