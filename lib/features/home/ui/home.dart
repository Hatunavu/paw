import 'package:demo_git/features/fill_user/bloc/avt_picker_cubit.dart';
import 'package:demo_git/features/home/bloc/post_cubit.dart';
import 'package:demo_git/features/notification/bloc/noti_cubit.dart';
import 'package:demo_git/features/post/add_post_page.dart';
import 'package:demo_git/features/home/ui/home_page.dart';
import 'package:demo_git/features/notification/ui/noti_page.dart';
import 'package:demo_git/features/post/bloc/add_post_cubit.dart';
import 'package:demo_git/features/post/bloc/location_cubit.dart';
import 'package:demo_git/features/profile/bloc/follow_cubit.dart';
import 'package:demo_git/features/profile/bloc/following_cubit.dart';
import 'package:demo_git/features/profile/bloc/post_user_cubit.dart';
import 'package:demo_git/features/profile/bloc/profile_cubit.dart';
import 'package:demo_git/features/profile/bloc/profile_state.dart';
import 'package:demo_git/features/profile/ui/profile_page.dart';
import 'package:demo_git/features/search/bloc/search_cubit.dart';
import 'package:demo_git/features/search/search_page.dart';
import 'package:demo_git/features/setting/bloc/location_setting_cubit.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:demo_git/shared/res/colors.dart';
import 'package:demo_git/shared/res/custom_icons_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  ProfileCubit _profileCubit;
  final tabs = [
    MultiBlocProvider(providers: [
      BlocProvider(
          create: (context) =>
              PostCubit(context.read<UserRepositoryImplement>())),
      BlocProvider(
          create: (context) => LocationSettingCubit(
              userRepository: context.read<UserRepositoryImplement>()))
    ], child: const HomePage()),
    BlocProvider(
      create: (context) => SearchCubit(context.read<UserRepositoryImplement>()),
      child: const SearchPage(),
    ),
    MultiBlocProvider(providers: [
      BlocProvider(
        create: (context) => AvtPickerCubit(),
      ),
      BlocProvider(
        create: (context) =>
            AddPostCubit(context.read<UserRepositoryImplement>()),
      ),
      BlocProvider(
        create: (context) => LocationCubit(),
      )
    ], child: const AddPostPage()),
    BlocProvider(
      create: (context) => NotiCubit(context.read<UserRepositoryImplement>()),
      child: const NotiPage(),
    ),
    MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) =>
                  ProfileCubit(context.read<UserRepositoryImplement>())),
          BlocProvider(
              create: (context) =>
                  PostUserCubit(context.read<UserRepositoryImplement>())),
          BlocProvider(
              create: (context) =>
                  FollowCubit(context.read<UserRepositoryImplement>())),
          BlocProvider(
              create: (context) =>
                  FollowingCubit(context.read<UserRepositoryImplement>()))
        ],
        child: ProfilePage(
          goBook: true,
          uid: _firebaseAuth.currentUser.uid,
          isBack: false,
        ))
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _profileCubit = context.read<ProfileCubit>();
    _profileCubit.getProfile(_firebaseAuth.currentUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: tabs,
        ),
        bottomNavigationBar: Container(
          height: 50,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(
                      color: Colors.grey.withOpacity(0.5), width: 0.1))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: Icon(
                    _selectedIndex == 0 ? CustomIcons.home_1 : CustomIcons.home,
                    size: 20,
                    color: secondBlack,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  }),
              IconButton(
                  icon: Icon(
                    _selectedIndex == 1
                        ? CustomIcons.search_1
                        : CustomIcons.search,
                    size: 20,
                    color: secondBlack,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  }),
              InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
                child: Container(
                  height: 35,
                  width: 35,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(13)),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              // IconButton(
              //     icon: Icon(
              //       CustomIcons.add,
              //       size: 30,
              //       color: primaryColor,
              //     ),
              //     onPressed: () {
              //       setState(() {
              //         _selectedIndex = 2;
              //       });
              //     }),
              BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, profileState) {
                if (profileState is ProfileStateSuccess) {
                  final read = profileState.userr.unreadNoti == 0;
                  return IconButton(
                      icon: Icon(
                        _selectedIndex == 3
                            ? CustomIcons.favorite_1
                            : read
                                ? CustomIcons.favorite
                                : CustomIcons.favorite_1,
                        size: 20,
                        color: read ? secondBlack : Colors.red,
                      ),
                      onPressed: () {
                        _profileCubit.readNoti();
                        setState(() {
                          _selectedIndex = 3;
                        });
                      });
                }
                return IconButton(
                    icon: Icon(
                      _selectedIndex == 3
                          ? CustomIcons.favorite_1
                          : CustomIcons.favorite,
                      size: 20,
                      color: secondBlack,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 3;
                      });
                    });
              }),
              IconButton(
                  icon: Icon(
                    _selectedIndex == 4 ? CustomIcons.user_1 : CustomIcons.user,
                    size: 20,
                    color: secondBlack,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 4;
                    });
                  }),
            ],
          ),
        ));
  }
}
