///for validators of text field
class Validators {
  /// Check for non-empty field
  static String? checkFieldEmpty(String? fieldContent) {
    final trimmedContent = fieldContent?.trim() ?? '';
    return trimmedContent.isEmpty ? 'This field is required' : null;
  }

  /// Check for valid phone number (assuming 10 digits required)
  static String? checkPhoneField(String? fieldContent) {
    final trimmed = fieldContent?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'This field is required';
    }
    // Accept between 10 and 15 digits
    if (!RegExp(r'^[0-9]{10,15}$').hasMatch(trimmed)) {
      return 'Invalid phone number';
    }
    return null;
  }

  /// Password validation (at least 6 characters)
  static String? checkPasswordField(String? fieldContent) {
    final trimmedContent = fieldContent?.trim() ?? '';
    if (trimmedContent.isEmpty) {
      return 'This field is required';
    } else if (trimmedContent.length < 6) {
      return 'The password should be at least 6 characters';
    }

    // else if (!RegExp(
    //         r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
    //     .hasMatch(trimmedContent)) {
    //   return 'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character';
    // }
    return null;
  }

  /// Confirm password check
  static String? checkConfirmPassword(
    String? fieldContent,
    String? prevPassword,
  ) {
    final checkPassword = checkPasswordField(fieldContent);
    if (checkPassword != null) {
      return checkPassword;
    }
    return (fieldContent != prevPassword) ? "Passwords do not match" : null;
  }

  /// Email validation
  static String? checkEmailField(String? fieldContent) {
    final trimmedContent = fieldContent?.trim() ?? '';
    if (trimmedContent.isEmpty) {
      return 'This field is required';
    } else if (!RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(trimmedContent)) {
      return 'Invalid email address';
    }
    return null;
  }

  // OTP validation (assuming a 6-digit numeric OTP)
  static String? checkPinField(String? fieldContent) {
    final trimmedContent = fieldContent?.trim() ?? '';
    if (trimmedContent.isEmpty) {
      return 'This field is required';
    } else if (fieldContent?.length != 6) {
      return 'OTP Code is 6 characters';
    } else if (!RegExp(r'^[0-9]{6}$').hasMatch(trimmedContent)) {
      return 'Invalid OTP';
    }
    return null;
  }

  //Check URL validation
  static String? checkUrl(String? fieldContent) {
    final trimmedContent = fieldContent?.trim() ?? '';
    if (trimmedContent.isEmpty) {
      return 'This field is required';
    } else if (!(Uri.tryParse(trimmedContent)?.hasAbsolutePath ?? false)) {
      return 'Invalid URL';
    }
    return null;
  }
}
