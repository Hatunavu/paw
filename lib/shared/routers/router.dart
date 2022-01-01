import 'package:demo_git/data/model/health_book.dart';
import 'package:demo_git/data/model/notificationn.dart';
import 'package:demo_git/data/model/post.dart';
import 'package:demo_git/data/model/user_post.dart';
import 'package:demo_git/data/model/userr.dart';
import 'package:demo_git/features/around/bloc/around_cubit.dart';
import 'package:demo_git/features/around/ui/around_page.dart';
import 'package:demo_git/features/fill_user/bloc/avt_picker_cubit.dart';
import 'package:demo_git/features/fill_user/bloc/date_cubit.dart';
import 'package:demo_git/features/fill_user/bloc/fill_user_cubit.dart';
import 'package:demo_git/features/fill_user/ui/fill_user_page.dart';
import 'package:demo_git/features/health_book/bloc/fill_health_cubit.dart';
import 'package:demo_git/features/health_book/bloc/done_cubit.dart';
import 'package:demo_git/features/health_book/bloc/health_cubit.dart';
import 'package:demo_git/features/health_book/ui/health_book_page.dart';
import 'package:demo_git/features/health_book/ui/widget/fill_health_widget.dart';
import 'package:demo_git/features/health_book/ui/widget/detail_widget.dart';
import 'package:demo_git/features/home/bloc/comment_cubit.dart';
import 'package:demo_git/features/home/ui/widgets/comment_widget.dart';
import 'package:demo_git/features/profile/bloc/follow_cubit.dart';
import 'package:demo_git/features/profile/bloc/following_cubit.dart';
import 'package:demo_git/features/profile/bloc/post_user_cubit.dart';
import 'package:demo_git/features/profile/bloc/profile_cubit.dart';
import 'package:demo_git/features/profile/ui/profile_page.dart';
import 'package:demo_git/features/setting/ui/setting_page.dart';
import 'package:demo_git/features/splash/ui/login_home.dart';
import 'package:demo_git/features/splash/ui/onboarding_page.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static routeToProfile(
      {@required BuildContext context,
      @required UserRepository userRepository,
      @required String uid,
      @required bool isBack}) async {
    final page = MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ProfileCubit(userRepository)),
          BlocProvider(create: (context) => PostUserCubit(userRepository)),
          BlocProvider(create: (context) => FollowCubit(userRepository)),
          BlocProvider(create: (context) => FollowingCubit(userRepository))
        ],
        child: ProfilePage(
          goBook: false,
          uid: uid,
          isBack: true,
        ));
    return await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));
  }

  static routeToFillUser(
      {@required BuildContext context,
      @required UserRepository userRepository,
      @required Userr userr}) async {
    final page = MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AvtPickerCubit()),
          BlocProvider(create: (context) => FillUserCubit(userRepository)),
        ],
        child: FillUserPage(
          update: true,
          userr: userr,
        ));
    return await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));
  }

  static routeToComment(
      {@required BuildContext context,
      @required UserRepository userRepository,
      @required UserPost postUser,
      @required Userr userr,
      @required Post post,
      @required Notificationn notificationn}) async {
    final page = BlocProvider(
      create: (context) => CommentCubit(userRepository),
      child: CommentWidget(
        post: post,
        postUser: postUser,
        userr: userr,
        notificationn: notificationn,
      ),
    );
    return await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));
  }

  static routeToSetting({@required BuildContext context}) async {
    return await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SettingPage()));
  }

  static routeToLoginHome(BuildContext context) async {
    return await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginHome()));
  }

  static routeToOnboarding(BuildContext context) async {
    return await Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const OnboardingPage()));
  }

  static routeToAround(
    BuildContext context,
    UserRepository _userRepository,
  ) async {
    final page = BlocProvider(
      create: (context) => AroundCubit(_userRepository),
      child: const AroundPage(),
    );
    return await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));
  }

  static routeToHealthBook(
      BuildContext context, UserRepository _userRepository) async {
    final page = BlocProvider(
      create: (context) => HealthCubit(_userRepository),
      child: const HealthBookPage(),
    );

    return await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));
  }

  static routeToAddHealth(BuildContext context, UserRepository _userRepository,
      {@required HealthBook health, @required bool isUpdate}) async {
    final page = MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => DateCubit(),
          ),
          BlocProvider(
            create: (context) => FillHealthCubit(_userRepository),
          ),
          BlocProvider(create: (context) => DoneCubit())
        ],
        child: AddHealthWidget(
          health: health,
          isUpdate: isUpdate,
        ));

    return await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));
  }

  static routeToDetail(BuildContext context) async {
    final page = const DetailWidget();
    return await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));
  }
}
