import 'package:dalal_street_client/blocs/daily_challenges/daily_challenges_page_cubit.dart';
import 'package:dalal_street_client/blocs/daily_challenges/single_day_challenges/single_day_challenges_cubit.dart';
import 'package:dalal_street_client/components/failure_message.dart';
import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/pages/daily_challenges/single_day_challenges.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/range.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

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
                  return _DailyChallengesPageBody(successState: state);
                }
                return const Center(child: DalalLoadingBar());
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
  late String selectedDate;

  List<int> get days => 1.to(widget.successState.totalMarketDays);
  int get marketDay => widget.successState.marketDay;

  String dateForIndex(int tabIndex) {
    final diff = marketDay - (tabIndex + 1);
    final date = DateTime.now().subtract(Duration(days: diff));
    return DateFormat('dd MMM, yyyy').format(date);
  }

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
      setState(() => selectedDate = dateForIndex(_tabController.index));
    });
    _tabController.index = marketDay - 1;
    selectedDate = dateForIndex(_tabController.index);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  build(context) => Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: header(),
          ),
          const SizedBox(height: 12),
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

  Widget header() => Card(
        color: background2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Daily Challenges',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                selectedDate,
                style: const TextStyle(color: lightGray, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 10),
          ],
        ),
      );
}
