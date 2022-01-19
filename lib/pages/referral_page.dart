import 'dart:math';

import 'package:dalal_street_client/blocs/referral/referral_cubit.dart';
import 'package:dalal_street_client/config/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReferralPage extends StatefulWidget {
  const ReferralPage({ Key? key }) : super(key: key);

  @override
  _ReferralPageState createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  @override
  Widget build(BuildContext context) => BlocConsumer<ReferralCubit, ReferralState>(
listener: (context, state) {
          if (state is ReferralFailed) {
            logger.i(state.msg);
          }
          
        },
        builder: (context, state) => Scaffold(
          body: SafeArea(
            child: Container(child: createrefferalcode(state,context),),
          ),
        ),

    
    );

  createrefferalcode(state,BuildContext context) {
    context.read<ReferralCubit>().referralCode();
    if(state is ReferralSuccess) {
      logger.i(state.referralcode);
    }
  }
}