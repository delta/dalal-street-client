import 'package:dalal_street_client/blocs/referral/referral_bloc.dart';
import 'package:dalal_street_client/proto_build/models/User.pb.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReferralPage extends StatefulWidget {
  const ReferralPage({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  // ignore: no_logic_in_create_state
  _ReferralPageState createState() => _ReferralPageState(user.email);
}

class _ReferralPageState extends State<ReferralPage> {
  final String email;
  _ReferralPageState(this.email);

  @override
  void initState() {
    super.initState();

    context.read<ReferralBloc>().add(GetReferralCode(email));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: referralcode()));
  }
}

Widget referralcode() {
  return BlocBuilder<ReferralBloc, ReferralState>(builder: (context, state) {
    if (state is ReferralSuccess) {
      return Text(state.referralCode);
    } else if (state is ReferralFailed) {
      return Text(state.msg);
    } else {
      return const Center(
          child: CircularProgressIndicator(color: secondaryColor));
    }
  });
}
