import 'package:reactive_forms/reactive_forms.dart';

Map<String, String> emailValidation() => {
      ValidationMessage.required: 'Email must not be empty',
      ValidationMessage.email: 'Enter a valid email',
    };

Map<String, String> requiredValidation(String field) => {
      ValidationMessage.required: '$field must not be empty',
    };

Map<String, String> passwordValidation(String field) => {
      ValidationMessage.required: '$field must not be empty',
      ValidationMessage.mustMatch: 'Password and confirm password must match',
      ValidationMessage.minLength: '$field must have at least 6 characters'
    };

Map<String, String> phoneNumberValidation() => {
      ValidationMessage.required: 'This field is required',
      ValidationMessage.minLength: 'Invalid phone number',
      ValidationMessage.maxLength: 'Invalid phone number'
    };
