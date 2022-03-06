import 'package:dalal_street_client/blocs/auth/change_password/change_password_cubit.dart';
import 'package:dalal_street_client/components/dalal_back_button.dart';
import 'package:dalal_street_client/components/fill_max_height_scroll_view.dart';
import 'package:dalal_street_client/components/loading.dart';
import 'package:dalal_street_client/components/reactive_password_field.dart';
import 'package:dalal_street_client/models/snackbar/snackbar_type.dart';
import 'package:dalal_street_client/theme/colors.dart';
import 'package:dalal_street_client/utils/form_validation.dart';
import 'package:dalal_street_client/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ChangePasswordPage extends StatelessWidget {
  ChangePasswordPage({Key? key}) : super(key: key);

  final formGroup = FormGroup(
    {
      'temp password': FormControl(validators: [Validators.required]),
      'new password': FormControl(
          validators: [Validators.required, Validators.minLength(6)]),
      'confirm new password': FormControl(validators: [Validators.required]),
    },
    validators: [Validators.mustMatch('new password', 'confirm new password')],
  );

  @override
  build(context) => Scaffold(
        body: SafeArea(
          child: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
            listener: (context, state) {
              if (state is ChangePasswordFailure) {
                showSnackBar(context, state.msg, type: SnackBarType.error);
              } else if (state is ChangePasswordSuccess) {
                Navigator.maybePop(context);
                showSnackBar(context, state.msg, type: SnackBarType.success);
              }
            },
            builder: (context, state) {
              if (state is ChangePasswordLoading) {
                return const Center(child: DalalLoadingBar());
              }

              var screenwidth = MediaQuery.of(context).size.width;

              if (screenwidth > 1000) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: secondaryColor, width: 2),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: body(),
                  margin: EdgeInsets.fromLTRB(
                      screenwidth * 0.35,
                      screenwidth * 0.03,
                      screenwidth * 0.35,
                      screenwidth * 0.125),
                );
              }

              return body();
            },
          ),
        ),
      );

  Widget body() => FillMaxHeightScrollView(
        builder: (context) => Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              header(context),
              const SizedBox(height: 50),
              form(context),
            ],
          ),
        ),
      );

  Widget header(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DalalBackButton(),
          const SizedBox(height: 20),
          Text(
            'Reset Password',
            style: Theme.of(context).textTheme.headline1,
          ),
          const SizedBox(height: 5),
          Text(
            'Enter your new password',
            style: Theme.of(context).textTheme.headline6,
          ),
        ],
      );

  Widget form(BuildContext context) => SizedBox(
        child: ReactiveForm(
          formGroup: formGroup,
          child: Column(
            children: [
              ReactivePasswordField(
                formControlName: 'temp password',
                label: 'Temporary Password',
                validation: requiredValidation('temporary password'),
              ),
              const SizedBox(height: 20),
              ReactivePasswordField(
                formControlName: 'new password',
                label: 'New Password',
                validation: passwordValidation('new password'),
              ),
              const SizedBox(height: 20),
              ReactivePasswordField(
                formControlName: 'confirm new password',
                label: 'Confirm New Password',
                validation: passwordValidation('confirm new password'),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => onResetClick(context),
                  child: const Text('Reset Password'),
                ),
              ),
            ],
          ),
        ),
      );

  void onResetClick(BuildContext context) {
    if (formGroup.valid) {
      context.read<ChangePasswordCubit>().changePassword(
          formGroup.control('temp password').value,
          formGroup.control('new password').value,
          formGroup.control('confirm new password').value);
    } else {
      formGroup.markAllAsTouched();
    }
  }
}
