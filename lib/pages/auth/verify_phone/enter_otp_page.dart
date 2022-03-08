import 'package:dalal_street_client/blocs/auth/verify_phone/enter_otp/enter_otp_cubit.dart';
import 'package:dalal_street_client/components/fill_max_height_scroll_view.dart';
import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/navigation/nav_utils.dart';
import 'package:dalal_street_client/models/snackbar/snackbar_type.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/theme/theme.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EnterOtpPage extends StatefulWidget {
  const EnterOtpPage({Key? key}) : super(key: key);

  @override
  _EnterOtpPageState createState() => _EnterOtpPageState();
}

class _EnterOtpPageState extends State<EnterOtpPage> {
  late String _otp;

  @override
  Widget build(context) => Scaffold(
        body: SafeArea(
          child: BlocConsumer<EnterOtpCubit, OtpState>(
            listener: (context, state) {
              if (state is OtpFailure) {
                showSnackBar(context, state.msg, type: SnackBarType.error);
              } else if (state is OtpResent) {
                showSnackBar(context, 'Otp resent successfully',
                    type: SnackBarType.info);
              } else if (state is OtpSuccess) {
                showSnackBar(context, 'Phone Verified',
                    type: SnackBarType.success);
              }
            },
            builder: (context, state) {
              if (state is OtpInitial) {
                var screenwidth = MediaQuery.of(context).size.width;

                return screenwidth > 1000
                    ? (Center(
                        child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: secondaryColor, width: 2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: buildContent(state.phone),
                        margin: EdgeInsets.fromLTRB(
                            screenwidth * 0.35,
                            screenwidth * 0.03,
                            screenwidth * 0.35,
                            screenwidth * 0.1),
                      )))
                    : buildContent(state.phone);
              } else {
                return const Center(child: DalalLoadingBar());
              }
            },
          ),
        ),
      );

  Widget buildContent(String phone) => FillMaxHeightScrollView(
        builder: (context) => Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildHeader(phone),
              buildForm(phone),
            ],
          ),
        ),
      );

  Widget buildHeader(String phone) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verify Phone Number',
            style: Theme.of(context).textTheme.headline1,
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyText1,
              children: [
                const TextSpan(text: 'We have sent a verification code to\n'),
                TextSpan(
                  text: phone,
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget buildForm(String phone) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: PinCodeTextField(
              appContext: context,
              length: 4,
              keyboardType: TextInputType.number,
              onChanged: (s) => _otp = s,
              textStyle: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
              pinTheme: pinTextFieldTheme,
              onSubmitted: (_) => _onVerifyOTPClick(phone),
              textInputAction: TextInputAction.done,
            ),
          ),
          GestureDetector(
            onTap: () => _onResendOTPClick(phone),
            child: Align(
              child: Text(
                "Didn't recieve OTP?",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              alignment: Alignment.centerRight,
            ),
          ),
          const SizedBox(height: 50),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _onVerifyOTPClick(phone),
              child: const Text('Verify OTP'),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _onChangeNumberClick,
              child: const Text('Change Phone Number'),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: _onLogoutClick,
              child: const Text('Log Out'),
            ),
          ),
        ],
      );

  void _onResendOTPClick(String phone) {
    context.read<EnterOtpCubit>().resendOTP();
  }

  void _onVerifyOTPClick(String phone) {
    // TODO: improve validation later
    if (_otp.length < 4) {
      showSnackBar(context, 'Invalid Otp', type: SnackBarType.error);
      return;
    }
    context.read<EnterOtpCubit>().verifyOTP(int.parse(_otp), phone);
  }

  void _onChangeNumberClick() => context.webGo('/enterPhone');

  void _onLogoutClick() => context.read<EnterOtpCubit>().logout();
}
