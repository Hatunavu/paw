import 'package:demo_git/features/home/bloc/comment_cubit.dart';
import 'package:demo_git/features/home/bloc/like_cubit.dart';
import 'package:demo_git/features/home/bloc/post_cubit.dart';
import 'package:demo_git/features/home/bloc/post_state.dart';
import 'package:demo_git/features/home/ui/widgets/post_card_widget.dart';
import 'package:demo_git/features/setting/bloc/location_setting_cubit.dart';
import 'package:demo_git/features/setting/bloc/location_setting_state.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:demo_git/shared/res/colors.dart';
import 'package:demo_git/shared/routers/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserRepository _userRepository;
  PostCubit _postCubit;
  LocationSettingCubit _locationSettingCubit;
  final ScrollController _scrollController = ScrollController();
  final _scrollTreadhold = 250;
  @override
  void initState() {
    super.initState();
    _userRepository = context.read<UserRepositoryImplement>();
    _postCubit = context.read<PostCubit>();
    _locationSettingCubit = context.read<LocationSettingCubit>();
    _postCubit.getPost();
    _locationSettingCubit.isEnbaleLocation();
    _scrollController.addListener(() {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScrollExtent - currentScroll <= _scrollTreadhold) {
        _postCubit.getPost();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0.1,
            centerTitle: false,
            title: Text(
              'Paw',
              style: TextStyle(
                fontFamily: 'Pacifico',
                color: primaryColor,
                fontSize: 30,
              ),
            ),
          ),
        ),
        floatingActionButton:
            BlocBuilder<LocationSettingCubit, LocationSettingState>(
                builder: (context, locationState) {
          if (locationState is LocationSettingStateSuccess) {
            return locationState.enableLocation
                ? Container(
                    width: 45,
                    height: 45,
                    child: RawMaterialButton(
                      fillColor: primaryColor,
                      shape: const CircleBorder(),
                      child: const Icon(
                        Icons.location_on_outlined,
                        size: 28,
                        color: Colors.white,
                      ),
                      onPressed: () =>
                          AppRouter.routeToAround(context, _userRepository),
                    ),
                  )
                : Container();
          }
          return Container();
        }),
        backgroundColor: Colors.white,
        body: RefreshIndicator(
            onRefresh: () async {
              _postCubit.emit(PostStateInitial());
              await _postCubit.getPost();
            },
            child: BlocBuilder<PostCubit, PostState>(
              buildWhen: (previous, current) {
                return current is PostStateSuccess;
              },
              builder: (context, postState) {
                if (postState is PostStateInitial) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (postState is PostStateFailure) {
                  return const Center(
                    child: Text('Cannot load data from server'),
                  );
                }
                if (postState is PostStateSuccess) {
                  if (postState.posts.isEmpty) {
                    return const Center(
                      child: Text('Empty post'),
                    );
                  }
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      if (index >= postState.posts.length) {
                        return Container(
                          alignment: Alignment.center,
                          child: const Center(
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        );
                      } else {
                        final post = postState.posts[index];
                        return MultiBlocProvider(
                          providers: [
                            BlocProvider(
                                create: (context) =>
                                    LikeCubit(_userRepository)),
                            BlocProvider(
                                create: (context) =>
                                    CommentCubit(_userRepository))
                          ],
                          child: PostCardWidget(
                            post: post,
                            postUser: null,
                            userr: null,
                            notificationn: null,
                            border: true,
                            goComment: true,
                            goProfile: true,
                          ),
                        );
                      }
                    },
                    itemCount: postState.hasReachedEnd
                        ? postState.posts.length
                        : postState.posts.length + 1,
                    controller: _scrollController,
                  );
                }
                return const Center(
                  child: Text('Other state...'),
                );
              },
            )));
  }
}
