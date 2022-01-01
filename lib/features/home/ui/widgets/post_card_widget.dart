import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_git/data/model/notificationn.dart';
import 'package:demo_git/data/model/post.dart';
import 'package:demo_git/data/model/user_post.dart';
import 'package:demo_git/data/model/userr.dart';
import 'package:demo_git/features/home/bloc/comment_cubit.dart';
import 'package:demo_git/features/home/bloc/comment_state.dart';
import 'package:demo_git/features/home/bloc/like_cubit.dart';
import 'package:demo_git/features/home/bloc/like_state.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:demo_git/shared/res/colors.dart';
import 'package:demo_git/shared/res/custom_icons_icons.dart';
import 'package:demo_git/shared/routers/router.dart';
import 'package:demo_git/shared/widgets/avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demo_git/shared/extension/difference_time.dart';
import 'package:provider/src/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostCardWidget extends StatefulWidget {
  final Post post;
  final UserPost postUser;
  final Notificationn notificationn;
  final Userr userr;
  final bool border;
  final bool goComment;
  final bool goProfile;

  const PostCardWidget(
      {Key key,
      @required this.post,
      @required this.postUser,
      @required this.notificationn,
      @required this.border,
      @required this.goComment,
      @required this.userr,
      @required this.goProfile})
      : super(key: key);

  @override
  _PostCardWidgetState createState() => _PostCardWidgetState();
}

class _PostCardWidgetState extends State<PostCardWidget> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  LikeCubit _likeCubit;
  CommentCubit _commentCubit;
  UserRepository _userRepository;
  Post get post => widget.post;
  UserPost get postUser => widget.postUser;
  Notificationn get notification => widget.notificationn;
  Userr get userr => widget.userr;

  @override
  initState() {
    super.initState();
    _commentCubit = context.read<CommentCubit>();
    _likeCubit = context.read<LikeCubit>();
    _userRepository = context.read<UserRepositoryImplement>();
    _likeCubit.getLiked(post?.id ?? postUser?.id ?? notification.postId);
    _commentCubit.getComment(post?.id ?? postUser?.id ?? notification.postId);
  }

  void goToProfile() {
    widget.goProfile
        ? AppRouter.routeToProfile(
            context: context,
            userRepository: _userRepository,
            uid: post?.user?.uid ?? userr?.uid ?? notification.userPush.uid,
            isBack: true)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations text = AppLocalizations.of(context);
    final double width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: widget.border
              ? Border(top: BorderSide(color: borderColor, width: 1))
              : null),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    InkWell(
                        onTap: goToProfile,
                        child: Avatar(
                          size: 35,
                          imageUrl: post?.user?.avatar ??
                              userr?.avatar ??
                              notification.userPull.avatar,
                          margin: 10,
                        )),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: goToProfile,
                            child: Text(
                              post?.user?.petName ??
                                  userr?.petName ??
                                  notification.userPull.petName,
                              style: TextStyle(
                                  color: primaryBlack,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            DifferenceTime(post?.createdAt ??
                                    postUser?.createdAt ??
                                    notification.createdPost)
                                .parseString(text),
                            style: const TextStyle(
                                fontSize: 10, color: Colors.grey),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Icon(
                Icons.more_horiz,
                color: secondBlack,
                size: 15,
              ),
              const SizedBox(
                width: 20,
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            height: width - 150,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: CachedNetworkImage(
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    height: width - 150,
                    decoration: BoxDecoration(
                      color: backgroundLogin,
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                imageUrl: post?.image ?? postUser?.image ?? notification.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Row(
                  children: [
                    BlocBuilder<LikeCubit, LikeState>(
                        builder: (context, likeState) {
                      if (likeState is LikeStateSuccess) {
                        return InkWell(
                            onTap: () {
                              likeState.isLiked
                                  ? _likeCubit.dislikePost(
                                      postId: post?.id ??
                                          postUser?.id ??
                                          notification.postId,
                                      uid: post?.user?.uid ??
                                          userr?.uid ??
                                          notification.userPull.uid)
                                  : _likeCubit.likePost(
                                      post: post,
                                      postId: post?.id ??
                                          postUser?.id ??
                                          notification.postId,
                                      uid: post?.user?.uid ??
                                          userr?.uid ??
                                          notification.userPull.uid);
                            },
                            child: Row(
                              children: [
                                likeState.isLiked
                                    ? const Icon(
                                        CustomIcons.favorite_1,
                                        color: Colors.red,
                                        size: 18,
                                      )
                                    : const Icon(
                                        CustomIcons.favorite,
                                        size: 18,
                                      ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  likeState.likes != null
                                      ? likeState?.likes?.length.toString()
                                      : '0',
                                  style: TextStyle(
                                      fontSize: 10, color: primaryBlack),
                                )
                              ],
                            ));
                      }
                      return Row(
                        children: [
                          const Icon(
                            CustomIcons.favorite,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            '0',
                            style: TextStyle(fontSize: 10, color: primaryBlack),
                          )
                        ],
                      );
                    }),
                    const SizedBox(
                      width: 30,
                    ),
                    InkWell(
                      onTap: () {
                        widget.goComment
                            ? AppRouter.routeToComment(
                                context: context,
                                userRepository: _userRepository,
                                postUser: null,
                                userr: null,
                                notificationn: null,
                                post: post)
                            : null;
                      },
                      child: Row(
                        children: [
                          const Icon(
                            CustomIcons.speech_bubble,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          BlocBuilder<CommentCubit, CommentState>(
                              builder: (context, commentState) {
                            if (commentState is CommentStateSuccess) {
                              return Text(
                                commentState.comments != null
                                    ? commentState?.comments?.length.toString()
                                    : '0',
                                style: TextStyle(
                                    fontSize: 10, color: primaryBlack),
                              );
                            }
                            return Text('0',
                                style: TextStyle(
                                    fontSize: 10, color: primaryBlack));
                          }),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            post?.caption ?? postUser?.caption ?? notification.caption,
            style: const TextStyle(fontSize: 13),
          )
        ],
      ),
    );
  }
}
