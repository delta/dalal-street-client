import 'package:dalal_street_client/blocs/daily_challenges/single_day_challenges/single_day_challenges_cubit.dart';
import 'package:dalal_street_client/config/get_it.dart';
import 'package:dalal_street_client/models/daily_challenge_info.dart';
import 'package:dalal_street_client/models/snackbar/snackbar_type.dart';
import 'package:dalal_street_client/pages/daily_challenges/components/single_day_progress.dart';
import 'package:dalal_street_client/pages/daily_challenges/components/daily_challenge_item.dart';
import 'package:dalal_street_client/streams/global_streams.dart';
import 'package:dalal_street_client/streams/transformations.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SingleDayChallenges extends StatefulWidget {
  final bool isChallengesOpen;
  final bool isCurrentDay;
  final int day;

  const SingleDayChallenges(
      {Key? key,
      required this.isChallengesOpen,
      required this.isCurrentDay,
      required this.day})
      : super(key: key);

  @override
  State<SingleDayChallenges> createState() => _SingleDayChallengesState();
}

class _SingleDayChallengesState extends State<SingleDayChallenges>
    with AutomaticKeepAliveClientMixin {
  final stocks = getIt<GlobalStreams>().latestStockMap;

  Stream<bool> get isOpenStream => getIt<GlobalStreams>()
      .gameStateStream
      .isDailyChallengesOpenStream()
      .distinct();

  @override
  void initState() {
    super.initState();
    context.read<SingleDayChallengesCubit>().getChallenges(widget.day);
  }

  @override
  build(context) {
    super.build(context);
    return BlocConsumer<SingleDayChallengesCubit, SingleDayChallengesState>(
      listener: (context, state) {
        if (state is SingleDayChallengesFailure) {
          showSnackBar(context, state.msg, type: SnackBarType.error);
        }
      },
      builder: (context, state) {
        if (state is SingleDayChallengesLoaded) {
          if (!widget.isCurrentDay) {
            return content(state);
          }
          // Update isOpen state only for current day challenges
          return StreamBuilder<bool>(
            stream: isOpenStream,
            initialData: widget.isChallengesOpen,
            builder: (context, snapshot) {
              final isOpen = snapshot.data!;
              if (isOpen) {
                return content(state);
              }
              return const Center(
                  child: Text('Daily Challenges is closed for now'));
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget content(SingleDayChallengesLoaded state) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleDayProgress(challengeInfos: state.challengeInfos),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: challengesList(state.challengeInfos),
            ),
          ),
        ],
      );

  Widget challengesList(List<DailyChallengeInfo> challengeInfos) => Card(
        color: background2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Challenges',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  itemCount: challengeInfos.length,
                  itemBuilder: (_, i) => DailyChallengeItem(
                    isCurrentDay: widget.isCurrentDay,
                    challenge: challengeInfos[i].challenge,
                    userState: challengeInfos[i].userState,
                    stock: challengeInfos[i].challenge.hasStockId()
                        ? stocks[challengeInfos[i].challenge.stockId]
                        : null,
                  ),
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                ),
              ),
            ],
          ),
        ),
      );

  // For preserving state between tab view pages: https://stackoverflow.com/questions/49087703/preserving-state-between-tab-view-pages
  @override
  bool get wantKeepAlive => true;
}
