import 'package:clipboard/clipboard.dart';
import 'package:dalal_street_client/blocs/referral/referral_cubit.dart';
import 'package:dalal_street_client/models/snackbar/snackbar_type.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReferralPage extends StatelessWidget {
  const ReferralPage({
    Key? key,
    required this.user,
  }) : super(key: key);
  final User user;
  static const bool showbutton = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(
      child:
          BlocBuilder<ReferralCubit, ReferralState>(builder: (context, state) {
        if (state is ReferralSuccess) {
          return referralPageUi(!showbutton, state.referralCode, context);
        } else if (state is ReferralFailed) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Failed to Fetch the Referral Code'),
              const SizedBox(height: 20),
              SizedBox(
                width: 100,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    context.read<ReferralCubit>().getReferralcode(user.email);
                  },
                  child: const Text('Retry'),
                ),
              ),
            ],
          ));
        } else {
          return referralPageUi(showbutton, null, context);
        }
      }),
    ));
  }

  Widget referralPageUi(
      bool showbutton, String? referralcode, BuildContext context) {
    return SafeArea(
        child: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Stack(children: <Widget>[
              Positioned(
                child: Image.asset('assets/images/Background.png'),
              ),
              Positioned(
                child: Image.asset('assets/images/Referral.png'),
                left: 60,
                top: 50,
              )
            ]),
            const Padding(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 40),
                child: Text(
                  'Referral Code',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                )),
            const Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Flexible(
                    child: Text(
                  'Refer your friends to earn a cash reward',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ))),
            const SizedBox(height: 50),
            buttonWidget(showbutton, referralcode, context),
            const Padding(
                padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
                child: Text('How it works ?',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            const Flexible(
                child: Text(
              'Refer your friends to Dalal Street, and if they sign up, both of you will get a cash reward.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ))
          ]),
    ));
  }

  Widget buttonWidget(
      bool showbutton, String? referralcode, BuildContext context) {
    if (!showbutton) {
      return SizedBox(
          width: 300,
          height: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Your referral code is',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )),
              GestureDetector(
                  child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        Positioned(
                            child: Image.asset(
                          'assets/images/Rectangle 23.png',
                          width: 300,
                          fit: BoxFit.fitWidth,
                        )),
                        Positioned(
                            child: Text(
                          referralcode!,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: primaryColor),
                        ))
                      ]),
                  onTap: () async {
                    await FlutterClipboard.copy(referralcode);
                    showSnackBar(context, '✓   Copied to Clipboard',
                        type: SnackBarType.success);
                  }),
            ],
          ));
    } else {
      return SizedBox(
        width: 300,
        child: ElevatedButton(
            onPressed: () {
              context.read<ReferralCubit>().getReferralcode(user.email);
            },
            child: const Expanded(
                child: Text('Generate Referral Code',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))),
      );
    }
  }
}
