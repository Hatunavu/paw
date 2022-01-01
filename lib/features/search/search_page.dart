import 'package:cached_network_image/cached_network_image.dart';
import 'package:demo_git/data/model/userr.dart';
import 'package:demo_git/features/search/bloc/search_cubit.dart';
import 'package:demo_git/features/search/bloc/search_state.dart';
import 'package:demo_git/repository/user_repository.dart';
import 'package:demo_git/shared/res/colors.dart';
import 'package:demo_git/shared/res/images.dart';
import 'package:demo_git/shared/routers/router.dart';
import 'package:demo_git/shared/utils/debounce.dart';
import 'package:demo_git/shared/utils/function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/src/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  SearchCubit _searchCubit;
  UserRepository _userRepository;
  final _debouncer = Debouncer(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _searchCubit = context.read<SearchCubit>();
    _userRepository = context.read<UserRepositoryImplement>();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    return GestureDetector(
        onTap: () => unfocus(context),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.3,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        unfocus(context);
                        _searchController.clear();
                        _searchCubit.emit(null);
                      },
                      child: Text(
                        text.cancel,
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  ),
                )
              ],
              titleSpacing: 10,
              title: TextFormField(
                  onChanged: (String text) {
                    _debouncer.run(() {
                      text == ''
                          ? _searchCubit.emit(null)
                          : _searchCubit.seachUserr(text);
                    });
                  },
                  controller: _searchController,
                  cursorColor: primaryColor,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(
                          top: 0, bottom: 0, left: 15, right: 0),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(10)),
                      hintText: text.search,
                      filled: true,
                      fillColor: backgroundLogin,
                      prefixIcon: Icon(
                        Icons.search,
                        color: primaryColor,
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _searchCubit.emit(null);
                          },
                          icon: Icon(
                            Icons.clear,
                            color: primaryColor,
                          ))))),
          body: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, searchState) {
              if (searchState is SearchStateSuccess) {
                return _searchController.text == ''
                    ? Center(
                        child: SvgPicture.asset(imageSearch,
                            color: backgroundLogin))
                    : searchState.resultsList.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              '${text.no_result}\"${_searchController.text}\"',
                              style: const TextStyle(color: Colors.black),
                            ),
                          )
                        : ListView.builder(
                            itemCount: searchState.resultsList.length,
                            itemBuilder: (context, index) {
                              final userr = searchState.resultsList[index];
                              return InkWell(
                                  onTap: () {
                                    AppRouter.routeToProfile(
                                        context: context,
                                        userRepository: _userRepository,
                                        uid: userr.uid,
                                        isBack: true);
                                  },
                                  child: UserrResult(userr: userr));
                            },
                          );
              } else if (searchState is SearchStateLoading) {
                return const SearchShimmer();
              }
              return Center(
                child: Center(
                    child:
                        SvgPicture.asset(imageSearch, color: backgroundLogin)),
              );
            },
          ),
        ));
  }
}

class UserrResult extends StatelessWidget {
  final Userr userr;
  const UserrResult({Key key, @required this.userr}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white10,
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: backgroundLogin,
              child: Container(
                height: 100,
                width: 100,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300],
                        highlightColor: Colors.grey[100],
                        child: const CircleAvatar(),
                      ),
                      imageUrl: userr.avatar,
                      fit: BoxFit.cover,
                    )),
              ),
            ),
            title: Text(userr.petName),
          ),
          const Divider(
            height: 2,
          )
        ],
      ),
    );
  }
}

class SearchShimmer extends StatelessWidget {
  const SearchShimmer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return ListView.builder(
      itemBuilder: (context, index) {
        return Column(
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300],
              highlightColor: Colors.grey[100],
              child: ListTile(
                leading: const CircleAvatar(),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: width / 2,
                      height: 8.0,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.0),
                    ),
                    Container(
                      width: width / 3,
                      height: 8.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 2,
            )
          ],
        );
      },
      itemCount: 20,
    );
  }
}
