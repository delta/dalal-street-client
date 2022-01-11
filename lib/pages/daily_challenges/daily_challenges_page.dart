import 'package:dalal_street_client/blocs/daily_challenges/daily_challenges_page_cubit.dart';
import 'package:dalal_street_client/blocs/daily_challenges/single_day_challenges/single_day_challenges_cubit.dart';
import 'package:dalal_street_client/components/failure_message.dart';
import 'package:dalal_street_client/pages/daily_challenges/single_day_challenges.dart';
import 'package:dalal_street_client/utils/range.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// TODO: Disable swiping until this is resolved properly: https://github.com/flutter/flutter/issues/31206
class DailyChallengesPage extends StatelessWidget {
  const DailyChallengesPage({Key? key}) : super(key: key);

  @override
  build(context) => Scaffold(
        body: SafeArea(
          child: Center(
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
                  if (state.isDailyChallengesOpen) {
                    return _DailyChallengesPageBody(successState: state);
                  } else {
                    return const Center(
                      child: Text('Daily Challenges is closed now'),
                    );
                  }
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      );

  void onRetryClick(BuildContext context) =>
      context.read<DailyChallengesPageCubit>().getChallengesConfig();
}

class _DailyChallengesPageBody extends StatefulWidget {
  const _DailyChallengesPageBody({
    Key? key,
    required this.successState,
  }) : super(key: key);

  final DailyChallengesPageSuccess successState;

  @override
  State<_DailyChallengesPageBody> createState() =>
      _DailyChallengesPageBodyState();
}

class _DailyChallengesPageBodyState extends State<_DailyChallengesPageBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<int> get days => 1.to(widget.successState.totalMarketDays);
  int get marketDay => widget.successState.marketDay;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.successState.totalMarketDays, vsync: this);
    _tabController.addListener(() {
      if ((_tabController.index + 1) > marketDay) {
        int index = _tabController.previousIndex;
        setState(() => _tabController.index = index);
      }
    });
    _tabController.index = marketDay - 1;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  build(context) => Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: [
              for (final day in days)
                Tab(
                  text: 'Day $day',
                  icon: Icon(
                    (day <= marketDay) ? Icons.lock_open : Icons.lock,
                  ),
                )
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              // Disable Scrolling
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final day in days)
                  BlocProvider(
                    create: (_) => SingleDayChallengesCubit(),
                    child: SingleDayChallenges(
                      marketDay: marketDay,
                      day: day,
                    ),
                  )
              ],
            ),
          ),
        ],
      );
}
