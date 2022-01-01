import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_git/data/model/user_post.dart';
import 'package:demo_git/features/health_book/ui/widget/health_book_button.dart';
import 'package:demo_git/features/profile/bloc/follow_cubit.dart';
import 'package:demo_git/features/profile/bloc/follow_state.dart';
import 'package:demo_git/features/profile/bloc/following_cubit.dart';
import 'package:demo_git/features/profile/bloc/following_state.dart';
import 'package:demo_git/features/profile/bloc/post_user_cubit.dart';
import 'package:demo_git/features/profile/bloc/post_user_state.dart';
import 'package:demo_git/features/profile/bloc/profile_cubit.dart';
import 'package:demo_git/features/profile/bloc/profile_state.dart';
import 'package:demo_git/features/profile/ui/widget/follow_button.dart';
import 'package:demo_git/features/profile/ui/widget/header.dart';
import 'package:demo_git/features/profile/ui/widget/infor.dart';
import 'package:demo_git/features/profile/ui/widget/post_item.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:demo_git/shared/extension/format_date.dart';
import 'package:demo_git/shared/res/colors.dart';
import 'package:demo_git/shared/res/custom_icons_icons.dart';
import 'package:demo_git/shared/res/images.dart';
import 'package:demo_git/shared/routers/router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  final bool isBack;
  final bool goBook;
  const ProfilePage(
      {Key key,
      @required this.uid,
      @required this.isBack,
      @required this.goBook})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool get isBack => widget.isBack;
  UserRepository _userRepository;
  ProfileCubit _profileCubit;
  PostUserCubit _postUserCubit;
  FollowCubit _followCubit;
  FollowingCubit _followingCubit;
  bool isMainUser;
  @override
  initState() {
    super.initState();
    _userRepository = context.read<UserRepositoryImplement>();
    _postUserCubit = context.read<PostUserCubit>();
    _profileCubit = context.read<ProfileCubit>();
    _followCubit = context.read<FollowCubit>();
    _followingCubit = context.read<FollowingCubit>();
    _profileCubit.getProfile(widget.uid);
    _followingCubit.getFollowing(uid: widget.uid);
    _postUserCubit.getPostUser(widget.uid);
    _followCubit.getFollower(uid: widget.uid);
    isMainUser = widget.uid == _firebaseAuth.currentUser.uid ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    return BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, profileState) {
      if (profileState is ProfileStateSuccess) {
        final userr = profileState.userr;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: Stack(
              children: [
                AppBar(
                  title: Text(
                    userr.petName,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.white,
                  elevation: 0.3,
                  automaticallyImplyLeading: false,
                  leading: isBack
                      ? IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                            size: 20,
                          ),
                          onPressed: () {
                            Navigator.pop(context, true);
                          })
                      : null,
                  actions: isBack
                      ? isMainUser
                          ? null
                          : [
                              FollowButton(
                                  followCubit: _followCubit,
                                  uid: widget.uid,
                                  userr: userr)
                            ]
                      : [
                          IconButton(
                              icon: const Icon(
                                CustomIcons.menu,
                                color: Colors.black,
                                size: 15,
                              ),
                              onPressed: () {
                                AppRouter.routeToSetting(context: context);
                              })
                        ],
                ),
                widget.goBook
                    ? SafeArea(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 10,
                            ),
                            HealthBookButton(
                              onPress: () => AppRouter.routeToHealthBook(
                                  context, _userRepository),
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                          height: 100,
                          width: 100,
                          color: backgroundLogin,
                          child: CachedNetworkImage(
                            imageUrl: userr.avatar,
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
                          )),
                    ),
                    Positioned(
                        right: 5,
                        bottom: 0,
                        child: isMainUser
                            ? InkWell(
                                onTap: () => AppRouter.routeToFillUser(
                                    context: context,
                                    userRepository: _userRepository,
                                    userr: userr),
                                child: Container(
                                  height: 28,
                                  width: 28,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child: Container(
                                    height: 25,
                                    width: 25,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xff583da1)),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              )
                            : Container())
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Infor(
                    data: userr?.gender == 1 ? text.male : text.female,
                    content: text.gender),
                Infor(data: userr.species, content: text.species),
                Infor(data: userr.bossName, content: text.boss_name),
                Infor(data: userr.favoriteFood, content: text.favorite_food),
                Infor(
                    data: FormatDate(userr.dateOfBirth).format(),
                    content: text.date_of_birth),
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  height: 80,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xff583da1)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          BlocBuilder<PostUserCubit, PostUserState>(
                              builder: (context, postUserState) {
                            return Header(
                                data: postUserState?.postUser?.length != null
                                    ? postUserState?.postUser?.length.toString()
                                    : '0',
                                content: text.posts);
                          }),
                          BlocBuilder<FollowCubit, FollowState>(
                              builder: (context, followState) {
                            if (followState is FollowStateSuccess) {
                              return Header(
                                  data: followState?.followers?.length
                                          .toString() ??
                                      '0',
                                  content: text.follower);
                            }
                            return Header(data: '0', content: text.follower);
                          }),
                          BlocBuilder<FollowingCubit, FollowingState>(
                              builder: (context, followingState) {
                            if (followingState is FollowingStateSuccess) {
                              return Header(
                                  data: followingState?.following?.length
                                          .toString() ??
                                      '0',
                                  content: text.following);
                            }
                            return Header(data: '0', content: text.following);
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    color: Colors.grey.withOpacity(0.5),
                  ),
                ),
                BlocBuilder<PostUserCubit, PostUserState>(
                    builder: (context, postUserState) {
                  if (postUserState?.postUser?.length == 0 ||
                      postUserState?.postUser == null) {
                    return Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: Center(
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              logo2,
                              color: Colors.grey.shade400,
                              height: 100,
                              width: 100,
                            ),
                            Text(
                              text.no_post,
                              style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              text.posts,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: GridView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: postUserState?.postUser?.length,
                          itemBuilder: (BuildContext context, int index) {
                            final UserPost _postUser = UserPost.fromDoc(
                                postUserState?.postUser[index]);
                            return InkWell(
                                onTap: () => AppRouter.routeToComment(
                                    context: context,
                                    userRepository: _userRepository,
                                    postUser: _postUser,
                                    userr: userr,
                                    post: null,
                                    notificationn: null),
                                child: PostItem(
                                  image: _postUser.image,
                                ));
                          },
                        ),
                      ),
                    ],
                  );
                })
              ],
            ),
          ),
        );
      }
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
