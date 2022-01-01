import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_git/shared/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PostItem extends StatelessWidget {
  final String image;
  const PostItem({Key key, @required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: CachedNetworkImage(
        imageUrl: image,
        fit: BoxFit.cover,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Container(
            width: 100,
            height: 100,
            color: backgroundLogin,
          ),
        ),
      ),
    );
  }
}
