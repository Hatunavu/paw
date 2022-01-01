import 'package:demo_git/data/model/health_book.dart';
import 'package:demo_git/features/health_book/bloc/health_cubit.dart';
import 'package:demo_git/features/health_book/bloc/health_state.dart';
import 'package:demo_git/features/health_book/ui/widget/detail_card.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:demo_git/shared/extension/format_date.dart';
import 'package:demo_git/shared/res/images.dart';
import 'package:demo_git/shared/routers/router.dart';
import 'package:demo_git/shared/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/src/provider.dart';

class HealthBookPage extends StatefulWidget {
  const HealthBookPage({Key key}) : super(key: key);

  @override
  _HealthBookPageState createState() => _HealthBookPageState();
}

class _HealthBookPageState extends State<HealthBookPage> {
  HealthCubit _healthCubit;
  UserRepository _userRepository;
  final ScrollController _scrollController = ScrollController();
  final _scrollTreadhold = 250;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _healthCubit = context.read<HealthCubit>();
    _userRepository = context.read<UserRepositoryImplement>();
    _healthCubit.getHealth();
    _scrollController.addListener(() {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (maxScrollExtent - currentScroll <= _scrollTreadhold) {
        _healthCubit.getHealth();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: AppBar(
            elevation: 0.3,
            backgroundColor: Colors.white,
            leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.pop(context, true);
                }),
            centerTitle: true,
            title: Text(text.health_book,
                style: const TextStyle(color: Colors.black, fontSize: 16)),
          ),
        ),
        body: Stack(
          children: [
            BlocBuilder<HealthCubit, HealthState>(
                builder: (context, healtState) {
              if (healtState is HealthStateInitial) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (healtState is HealthStateFailure) {
                return const Center(
                  child: Text('Cannot load data from server'),
                );
              }
              if (healtState is HealthStateSuccess) {
                if (healtState.healthBooks.isEmpty) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: width - 40,
                        child: Text(
                          text.let_create,
                          style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SvgPicture.asset(
                        logo2,
                        color: Colors.grey.shade400,
                        height: width - 200,
                        width: width - 200,
                      ),
                    ],
                  ));
                }
                return ListView.builder(
                  padding: const EdgeInsets.only(
                      bottom: 80, left: 20, right: 20, top: 20),
                  controller: _scrollController,
                  itemCount: healtState.hasReachedEnd
                      ? healtState.healthBooks.length
                      : healtState.healthBooks.length + 1,
                  itemBuilder: (context, index) {
                    if (index >= healtState.healthBooks.length) {
                      return healtState.healthBooks.length < 15
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
                      final HealthBook _heatlh = healtState.healthBooks[index];
                      return DetailCard(
                          schedule: FormatDate(_heatlh.schedule).format(),
                          title: _heatlh.title,
                          createdAt: FormatDate(_heatlh.createdAt).format(),
                          done: _heatlh.done,
                          onPressed: () => AppRouter.routeToAddHealth(
                              context, _userRepository,
                              health: _heatlh, isUpdate: true));
                    }
                  },
                );
              }
              return const Center(child: Text('Other state'));
            }),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ButtonWidget(
                      button: text.create_new,
                      onPress: () => AppRouter.routeToAddHealth(
                          context, _userRepository,
                          health: null, isUpdate: false)),
                ),
              ],
            )
          ],
        ));
  }
}
