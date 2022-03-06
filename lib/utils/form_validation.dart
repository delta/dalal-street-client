import 'package:reactive_forms/reactive_forms.dart';

Map<String, String> emailValidation() {
  return {
    ValidationMessage.required: 'The email must not be empty',
    ValidationMessage.email: 'The email value must be a valid email',
  };
}

Map<String, String> requiredValidation(String field) {
  return {
    ValidationMessage.required: 'The $field must not be empty',
  };
}

Map<String, String> passwordValidation(String field) {
  return {
    ValidationMessage.required: 'The $field must not be empty',
    ValidationMessage.mustMatch: 'password and confirm password must match',
    ValidationMessage.minLength: 'The $field must have at least 6 characters'
  };
}

Map<String, String> phoneNumberValidation() {
  return {
    ValidationMessage.required: 'This field is required',
    ValidationMessage.minLength: 'Invalid phone number',
    ValidationMessage.maxLength: 'Invalid phone number'
  };
}
