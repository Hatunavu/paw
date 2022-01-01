import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_git/data/model/comment.dart';
import 'package:demo_git/data/model/notificationn.dart';
import 'package:demo_git/data/model/post.dart';
import 'package:demo_git/data/model/user_post.dart';
import 'package:demo_git/data/model/userr.dart';
import 'package:demo_git/features/home/bloc/comment_cubit.dart';
import 'package:demo_git/features/home/bloc/comment_state.dart';
import 'package:demo_git/features/home/bloc/like_cubit.dart';
import 'package:demo_git/features/home/ui/widgets/comment_card_widget.dart';
import 'package:demo_git/features/home/ui/widgets/post_card_widget.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:demo_git/shared/res/colors.dart';
import 'package:demo_git/shared/res/custom_icons_icons.dart';
import 'package:demo_git/shared/utils/function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

class CommentWidget extends StatefulWidget {
  final Post post;
  final UserPost postUser;
  final Userr userr;
  final Notificationn notificationn;
  const CommentWidget(
      {Key key,
      @required this.post,
      @required this.postUser,
      @required this.userr,
      @required this.notificationn})
      : super(key: key);

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  UserRepository _userRepository;
  CommentCubit _commentCubit;
  final TextEditingController _commentController = TextEditingController();
  final _enable = ValueNotifier(false);
  String notiId = const Uuid().v4();

  @override
  initState() {
    super.initState();
    _userRepository = context.read<UserRepositoryImplement>();
    _commentCubit = context.read<CommentCubit>();
    _commentCubit.getComment(widget?.post?.id ??
        widget?.postUser?.id ??
        widget.notificationn.postId);
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => unfocus(context),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: AppBar(
            centerTitle: true,
            leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.pop(context);
                }),
            title: Text(
              text.comment,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            backgroundColor: Colors.white,
            elevation: 0.3,
          ),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        BlocProvider(
                          create: (context) => LikeCubit(_userRepository),
                          child: PostCardWidget(
                            post: widget?.post,
                            postUser: widget.postUser,
                            userr: widget.userr,
                            notificationn: widget.notificationn,
                            border: false,
                            goComment: false,
                            goProfile: false,
                          ),
                        ),
                        BlocBuilder<CommentCubit, CommentState>(
                            builder: (context, commentState) {
                          if (commentState is CommentStateSuccess) {
                            final List<DocumentSnapshot> comments =
                                commentState.comments;
                            return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: comments?.length ?? 0,
                              itemBuilder: (context, index) {
                                final Comment comment =
                                    Comment.fromDoc(comments[index]);
                                return CommentCardWidget(
                                  comment: comment,
                                );
                              },
                            );
                          }
                          return Container();
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Center(
                        child: Theme(
                          data: ThemeData(
                              primaryColor: Colors.grey.withOpacity(0.5)),
                          child: TextFormField(
                            onChanged: (text) {
                              _enable.value = text.isNotEmpty;
                            },
                            controller: _commentController,
                            minLines: 1,
                            maxLines: 3,
                            autofocus: true,
                            cursorColor: primaryColor,
                            style: const TextStyle(fontSize: 12),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              isDense: true,
                              errorStyle: const TextStyle(height: 0),
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(20)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(20)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(20)),
                              hintText: text.add_comment,
                              hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.withOpacity(0.8)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ValueListenableBuilder(
                      valueListenable: _enable,
                      builder: (context, value, _) {
                        return InkWell(
                            onTap: () {
                              if (value) {
                                _commentCubit.comment(
                                    notiId: notiId,
                                    uid: widget.post?.user?.uid ??
                                        widget.userr?.uid ??
                                        widget.notificationn.userPull.uid,
                                    post: widget?.post,
                                    postId: widget?.post?.id ??
                                        widget?.postUser?.id ??
                                        widget.notificationn.postId,
                                    comment: _commentController.text);
                                _commentController.clear();
                                unfocus(context);
                                _enable.value = false;
                                notiId = const Uuid().v4();
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 10, bottom: 10, right: 20),
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: value ? primaryColor : Colors.grey),
                              child: const Icon(
                                CustomIcons.send,
                                color: Colors.white,
                                size: 18,
                              ),
                            ));
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
