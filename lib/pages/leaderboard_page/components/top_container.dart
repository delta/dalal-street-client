import 'package:dalal_street_client/blocs/leaderboard/leaderboard_cubit.dart';
import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../leaderboard_page.dart';
import 'leaderboard_page_builder.dart';

Widget topContainer(leaderboardType, BuildContext context) {
  context.read<LeaderboardCubit>().getLeaderboard(1, 3, leaderboardType);
  return BlocBuilder<LeaderboardCubit, LeaderboardState>(
      builder: (context, state) {
    if (state is OverallLeaderboardSuccess) {
      var rankListSize = state.rankList.length;
      return rankListSize <= 3 ? Container() : Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: background2,
          ),
          width: double.infinity,
          child: Center(
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 25.0),
                              child: Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border:
                                          Border.all(color: silver, width: 2),
                                      image: const DecorationImage(
                                          image: AssetImage(
                                              'assets/images/Avatar2.png'),
                                          fit: BoxFit.fill))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border:
                                          Border.all(color: silver, width: 2),
                                      color: background2),
                                  child: const Text(
                                    '2',
                                    style: TextStyle(
                                        color: silver,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 130.0),
                              child: Column(
                                children: [
                                  Text(
                                    state.rankList[1].userName.toString(),
                                    style: const TextStyle(color: silver),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '₹ ' +
                                        oCcy
                                            .format(
                                                state.rankList[1].totalWorth)
                                            .toString(),
                                    style: const TextStyle(color: silver),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 35.0),
                              child: Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: gold, width: 3),
                                      image: const DecorationImage(
                                          image: AssetImage(
                                              'assets/images/Avatar1.png'),
                                          fit: BoxFit.fill))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 140),
                              child: Image.asset('assets/images/Crown.png',
                                  width: 50, height: 50),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: gold, width: 2),
                                      color: background2),
                                  child: const Text(
                                    '1',
                                    style: TextStyle(
                                        color: gold,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 130.0),
                              child: Column(
                                children: [
                                  Text(
                                    state.rankList[0].userName.toString(),
                                    style: const TextStyle(color: gold),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '₹ ' +
                                        oCcy
                                            .format(
                                                state.rankList[0].totalWorth)
                                            .toString(),
                                    style: const TextStyle(color: gold),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 25.0),
                              child: Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border:
                                          Border.all(color: bronze, width: 2),
                                      image: const DecorationImage(
                                          image: AssetImage(
                                              'assets/images/Avatar3.png'),
                                          fit: BoxFit.fill))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border:
                                          Border.all(color: bronze, width: 2),
                                      color: background2),
                                  child: const Text(
                                    '3',
                                    style: TextStyle(
                                        color: bronze,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 130.0),
                              child: Column(
                                children: [
                                  Text(
                                    state.rankList[2].userName.toString(),
                                    style: const TextStyle(color: bronze),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '₹ ' +
                                        oCcy
                                            .format(
                                                state.rankList[2].totalWorth)
                                            .toString(),
                                    style: const TextStyle(color: bronze),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: baseColor),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Row(
                            children: [
                              const Text(
                                'Your rank is ',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                state.myRank.toString(),
                                style: const TextStyle(
                                    color: secondaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                ' out of ',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                state.totalUsers.toString(),
                                style: const TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                ' participants. ',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          )))
                ],
              ),
              const SizedBox(height: 5),
            ]),
          ));
    } else if (state is DailyLeaderboardSuccess) {
      return Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: background2,
          ),
          width: double.infinity,
          child: Center(
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 25.0),
                              child: Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border:
                                          Border.all(color: silver, width: 2),
                                      image: const DecorationImage(
                                          image: AssetImage(
                                              'assets/images/Avatar1.png'),
                                          fit: BoxFit.fill))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border:
                                          Border.all(color: silver, width: 2),
                                      color: background2),
                                  child: const Text(
                                    '2',
                                    style: TextStyle(
                                        color: silver,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 130.0),
                              child: Column(
                                children: [
                                  Text(
                                    state.rankList[1].userName.toString(),
                                    style: const TextStyle(color: silver),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '₹ ' +
                                        oCcy
                                            .format(
                                                state.rankList[1].totalWorth)
                                            .toString(),
                                    style: const TextStyle(color: silver),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 35.0),
                              child: Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: gold, width: 3),
                                      image: const DecorationImage(
                                          image: AssetImage(
                                              'assets/images/Avatar2.png'),
                                          fit: BoxFit.fill))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 140),
                              child: Image.asset('assets/images/Crown.png',
                                  width: 50, height: 50),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: gold, width: 2),
                                      color: background2),
                                  child: const Text(
                                    '1',
                                    style: TextStyle(
                                        color: gold,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 130.0),
                              child: Column(
                                children: [
                                  Text(
                                    state.rankList[0].userName.toString(),
                                    style: const TextStyle(color: gold),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '₹ ' +
                                        oCcy
                                            .format(
                                                state.rankList[0].totalWorth)
                                            .toString(),
                                    style: const TextStyle(color: gold),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 25.0),
                              child: Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border:
                                          Border.all(color: bronze, width: 2),
                                      image: const DecorationImage(
                                          image: AssetImage(
                                              'assets/images/Avatar3.png'),
                                          fit: BoxFit.fill))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border:
                                          Border.all(color: bronze, width: 2),
                                      color: background2),
                                  child: const Text(
                                    '3',
                                    style: TextStyle(
                                        color: bronze,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 130.0),
                              child: Column(
                                children: [
                                  Text(
                                    state.rankList[2].userName.toString(),
                                    style: const TextStyle(color: bronze),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '₹ ' +
                                        oCcy
                                            .format(
                                                state.rankList[2].totalWorth)
                                            .toString(),
                                    style: const TextStyle(color: bronze),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: baseColor),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Row(
                            children: [
                              const Text(
                                'Your rank is ',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                state.myRank.toString(),
                                style: const TextStyle(
                                    color: secondaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                ' out of ',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                state.totalUsers.toString(),
                                style: const TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                ' participants. ',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          )))
                ],
              ),
              const SizedBox(height: 5),
            ]),
          ));
    } else if (state is LeaderboardFailure) {
      return LeaderboardPageBuilder(leaderboardType: leaderboardType);
    } else {
      return const Center(child: DalalLoadingBar());
    }
  });
}
