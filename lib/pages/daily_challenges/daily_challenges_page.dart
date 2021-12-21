import 'package:dalal_street_client/blocs/daily_challenges/daily_challenges_page_cubit.dart';
import 'package:dalal_street_client/blocs/daily_challenges/single_day_challenges/single_day_challenges_cubit.dart';
import 'package:dalal_street_client/components/failure_message.dart';
import 'package:dalal_street_client/pages/daily_challenges/single_day_challenges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailyChallengesPage extends StatelessWidget {
  const DailyChallengesPage({Key? key}) : super(key: key);

  @override
  build(context) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(title: const Text('Daily Challenges')),
          body: Center(
            child:
                BlocBuilder<DailyChallengesPageCubit, DailyChallengesPageState>(
              builder: (context, state) {
                if (state is DailyChallengesPageFailure) {
                  return FailureMessage(
                    msg: state.msg,
                    onClick: () => onRetryClick(context),
                  );
                }
                if (state is DailyChallengesPageSuccess) {
                  return Column(
                    children: [
                      const TabBar(
                        tabs: [
                          Tab(text: 'Day 1'),
                          Tab(text: 'Day 2'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: TabBarView(
                          children: [
                            BlocProvider(
                              create: (_) => SingleDayChallengesCubit(),
                              child: const SingleDayChallenges(day: 1),
                            ),
                            BlocProvider(
                              create: (_) => SingleDayChallengesCubit(),
                              child: const SingleDayChallenges(day: 2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      );

  void onRetryClick(BuildContext context) =>
      context.read<DailyChallengesPageCubit>().getConfig();
}
