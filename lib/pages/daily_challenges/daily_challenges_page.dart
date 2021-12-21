import 'package:dalal_street_client/blocs/daily_challenges/daily_challenges_page_cubit.dart';
import 'package:dalal_street_client/blocs/daily_challenges/single_day_challenges/single_day_challenges_cubit.dart';
import 'package:dalal_street_client/components/failure_message.dart';
import 'package:dalal_street_client/pages/daily_challenges/single_day_challenges.dart';
import 'package:dalal_street_client/utils/range.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DailyChallengesPage extends StatelessWidget {
  const DailyChallengesPage({Key? key}) : super(key: key);

  @override
  build(context) => Scaffold(
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
                return _DailyChallengesPageBody(successState: state);
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      );

  void onRetryClick(BuildContext context) =>
      context.read<DailyChallengesPageCubit>().getConfig();
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

// TODO: handle isDailyChallengesOpen field
class _DailyChallengesPageBodyState extends State<_DailyChallengesPageBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.successState.totalMarketDays, vsync: this);
    _tabController.addListener(() {
      if ((_tabController.index + 1) > widget.successState.marketDay) {
        int index = _tabController.previousIndex;
        setState(() => _tabController.index = index);
      }
    });
    _tabController.index = widget.successState.marketDay - 1;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = 1.to(widget.successState.totalMarketDays);
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            for (final day in days)
              Tab(
                text: 'Day $day',
                icon: Icon(
                  (day <= widget.successState.marketDay)
                      ? Icons.lock_open
                      : Icons.lock,
                ),
              )
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              for (final day in days)
                BlocProvider(
                  create: (_) => SingleDayChallengesCubit(),
                  child: SingleDayChallenges(day: day),
                )
            ],
          ),
        ),
      ],
    );
  }
}
