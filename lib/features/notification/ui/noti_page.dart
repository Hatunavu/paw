import 'package:demo_git/data/model/notificationn.dart';
import 'package:demo_git/features/notification/bloc/noti_cubit.dart';
import 'package:demo_git/features/notification/bloc/noti_state.dart';
import 'package:demo_git/features/notification/ui/widget/noti_card_widget.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:demo_git/shared/extension/noti_type.dart';
import 'package:demo_git/shared/res/images.dart';
import 'package:demo_git/shared/routers/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/src/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotiPage extends StatefulWidget {
  const NotiPage({Key key}) : super(key: key);

  @override
  _NotiPageState createState() => _NotiPageState();
}

class _NotiPageState extends State<NotiPage> {
  NotiCubit _notiCubit;
  UserRepository _userRepository;
  final ScrollController _scrollController = ScrollController();
  final _scrollTreadhold = 250;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _notiCubit = context.read<NotiCubit>();
    _userRepository = context.read<UserRepositoryImplement>();
    _notiCubit.getNoti();
    _scrollController.addListener(() {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScrollExtent - currentScroll <= _scrollTreadhold) {
        _notiCubit.getNoti();
      }
    });
  }

  void readNoti(Notificationn notification) {
    notification?.type == NotiType.follow.type
        ? AppRouter.routeToProfile(
            context: context,
            userRepository: _userRepository,
            uid: notification.userPush.uid,
            isBack: true)
        : AppRouter.routeToComment(
            context: context,
            userRepository: _userRepository,
            postUser: null,
            userr: null,
            post: null,
            notificationn: notification);
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: AppBar(
            title: Text(
              text.notification,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0.3,
            automaticallyImplyLeading: false,
          ),
        ),
        body: BlocBuilder<NotiCubit, NotiState>(
          builder: (context, notiState) {
            if (notiState is NotiStateInitial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (notiState is NotiStateFailure) {
              return const Center(
                child: Text('Cannot load data from server'),
              );
            }
            if (notiState is NotiStateSuccess) {
              if (notiState.notificationn.isEmpty) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      logo2,
                      color: Colors.grey.shade400,
                      height: 100,
                      width: 100,
                    ),
                    Text(
                      text.no_noti,
                      style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ));
              }
              return ListView.builder(
                controller: _scrollController,
                itemCount: notiState.hasReachedEnd
                    ? notiState.notificationn.length
                    : notiState.notificationn.length + 1,
                itemBuilder: (context, index) {
                  if (index >= notiState.notificationn.length) {
                    return notiState.notificationn.length < 15
                        ? Container()
                        : Container(
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
                    final Notificationn notification =
                        notiState.notificationn[index];
                    return InkWell(
                      onTap: () {
                        readNoti(notification);
                        _notiCubit.readFollow(id: notification.notiId);
                      },
                      child: NotiCardWidget(
                        notificationn: notification,
                      ),
                    );
                  }
                },
              );
            }
            return const Center(child: Text('Other state'));
          },
        ));
  }
}
