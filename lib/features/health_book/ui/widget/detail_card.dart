import 'package:demo_git/shared/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailCard extends StatelessWidget {
  final String title;
  final String schedule;
  final String createdAt;
  final bool done;
  final VoidCallback onPressed;
  const DetailCard(
      {Key key,
      @required this.schedule,
      @required this.title,
      @required this.createdAt,
      @required this.done,
      @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context);
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10, top: 5),
            child: Column(
              children: [
                Container(
                  height: 8,
                  width: 8,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xff8E8E8E),
                  ),
                ),
                Container(
                  width: 1,
                  height: 140,
                  color: const Color(0xff8E8E8E),
                )
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  createdAt,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff616161)),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  padding: const EdgeInsets.all(16),
                  height: 99,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: backgroundLogin,
                      borderRadius: BorderRadius.circular(10)),
                  child: InkWell(
                    onTap: onPressed,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${text.schedule}: $schedule',
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff616161)),
                            ),
                            Row(
                              children: [
                                Container(
                                    height: 16,
                                    width: 16,
                                    margin: const EdgeInsets.only(right: 6),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: done
                                            ? Colors.green
                                            : Colors.orange),
                                    child: Icon(
                                      done ? Icons.done : Icons.clear,
                                      size: 10,
                                      color: Colors.white,
                                    )),
                                done
                                    ? Text(
                                        text.accomplished,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green),
                                      )
                                    : Text(
                                        text.unfinished,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.orange),
                                      )
                              ],
                            )
                          ],
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Color(0xff8E8E8E),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
