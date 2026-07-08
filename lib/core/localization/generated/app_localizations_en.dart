// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get chooseYourLanguage => 'Choose your language';

  @override
  String get languageChangeHint =>
      'You can change the language later from settings.';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get continueLabel => 'Continue';

  @override
  String get onboardingTitle1 => 'Welcome to GrandeBeach';

  @override
  String get onboardingDescription1 =>
      'Discover the finest chalets and resorts for your perfect getaway.';

  @override
  String get onboardingTitle2 => 'Easy Booking';

  @override
  String get onboardingDescription2 =>
      'Book your stay in just a few taps with real-time availability.';

  @override
  String get onboardingTitle3 => 'Exclusive Rewards';

  @override
  String get onboardingDescription3 =>
      'Earn loyalty points and enjoy special promotions on every booking.';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get skip => 'Skip';

  @override
  String get loginToYourAccount => 'Login to your Account';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get signIn => 'Sign In';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get createAccount => 'Create your Account';

  @override
  String get firstName => 'First Name';

  @override
  String get firstNameHint => 'Enter your first name';

  @override
  String get lastName => 'Last Name';

  @override
  String get lastNameHint => 'Enter your last name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get phoneNumberHint => 'Enter your phone number';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get confirmPasswordHint => 'Re-enter your password';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get registrationSuccess =>
      'Account created successfully. Please sign in.';

  @override
  String get forgotPasswordTitle => 'Reset Your Password';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email and choose a new password.';

  @override
  String get newPassword => 'New Password';

  @override
  String get newPasswordHint => 'Enter new password';

  @override
  String get confirm => 'Confirm';

  @override
  String get resetPasswordSuccess =>
      'Password reset successfully. Please sign in.';

  @override
  String get errorTokenInvalid => 'The reset token is invalid or has expired.';

  @override
  String greeting(String firstName) {
    return 'Hi, $firstName!';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navDiscover => 'Discover';

  @override
  String get navBookings => 'Bookings';

  @override
  String get navProfile => 'Profile';

  @override
  String get discoverTitle => 'Discover';

  @override
  String get bookingsTitle => 'Bookings';

  @override
  String get profileTitle => 'Profile';

  @override
  String get notifications => 'Notifications';

  @override
  String get passwordRequirementsTitle => 'Your password must contain';

  @override
  String get passwordReqMinLength => 'At least 8 characters';

  @override
  String get passwordReqUppercase => 'One uppercase letter';

  @override
  String get passwordReqLowercase => 'One lowercase letter';

  @override
  String get passwordReqNumber => 'One number';

  @override
  String get passwordReqSpecialChar => 'One special character';

  @override
  String get errorEmailRequired => 'Email is required.';

  @override
  String get errorEmailInvalid => 'Please enter a valid email address.';

  @override
  String get errorPasswordRequired => 'Password is required.';

  @override
  String get errorPasswordTooShort => 'Password must be at least 6 characters.';

  @override
  String get errorPasswordRequirementsNotMet =>
      'Password does not meet the requirements above.';

  @override
  String get errorFirstNameRequired => 'First name is required.';

  @override
  String get errorLastNameRequired => 'Last name is required.';

  @override
  String get errorPhoneRequired => 'Phone number is required.';

  @override
  String get errorPhoneInvalid => 'Please enter a valid phone number.';

  @override
  String get errorConfirmPasswordRequired => 'Please confirm your password.';

  @override
  String get errorPasswordMismatch => 'Passwords do not match.';

  @override
  String get errorInvalidCredentials => 'Invalid credentials.';

  @override
  String get errorNoInternet =>
      'No internet connection. Please check your network and try again.';

  @override
  String get errorServer =>
      'Something went wrong on our end. Please try again later.';

  @override
  String get errorUnknown => 'An unexpected error occurred. Please try again.';

  @override
  String get errorNetwork => 'Unable to reach the server. Please try again.';

  @override
  String get noInternetTitle => 'No internet connection';

  @override
  String get noInternetMessage =>
      'Please check your Wi-Fi or mobile data and try again.';

  @override
  String get retry => 'Retry';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get accountInformation => 'Account Information';

  @override
  String get loyaltyPoints => 'Loyalty Points';

  @override
  String loyaltyPointsValue(String points) {
    return '$points pts';
  }

  @override
  String get wishlist => 'Wishlist';

  @override
  String get paymentMethods => 'Payment Methods';

  @override
  String get changePassword => 'Change Password';

  @override
  String get generalSettings => 'General Settings';

  @override
  String get language => 'Language';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmTitle => 'Logout';

  @override
  String get logoutConfirmMessage => 'Are you sure you want to logout?';

  @override
  String get logoutConfirm => 'Logout';

  @override
  String get cancel => 'Cancel';

  @override
  String get edit => 'Edit';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get save => 'Save';

  @override
  String get profileUpdatedSuccess => 'Profile updated successfully.';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get currentPasswordHint => 'Enter your current password';

  @override
  String get passwordChangedSuccess => 'Password changed successfully.';

  @override
  String get errorCurrentPasswordRequired => 'Current password is required.';

  @override
  String get emailNotEditable => 'Email address cannot be changed.';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get popularChalets => 'Popular Chalets';

  @override
  String get recentlyAdded => 'Recently Added';

  @override
  String get seeAll => 'See All';

  @override
  String get exploreMore => 'Explore More';

  @override
  String get perNight => '/night';

  @override
  String get reviews => 'reviews';

  @override
  String get kwdCurrency => 'KWD';

  @override
  String get discoverSearchHint => 'Find your perfect luxury stay';

  @override
  String get discoverChaletsTitle => 'Discover Our Chalets';

  @override
  String get noChaletsFound => 'No Chalets Found';

  @override
  String get noChaletsFoundSubtitle =>
      'There are currently no chalets available.';

  @override
  String get errorLoadingChalets =>
      'We couldn\'t load the chalets. Please try again.';

  @override
  String get searchSheetTitle => 'Find Your Perfect Chalet';

  @override
  String get searchSheetSubtitle =>
      'Choose one or more filters to discover the perfect stay.';

  @override
  String get filterWhenTitle => 'When';

  @override
  String get checkInLabel => 'Check-in';

  @override
  String get checkOutLabel => 'Check-out';

  @override
  String get filterChaletTypeTitle => 'Chalet Type';

  @override
  String get chaletTypeStandard => 'Standard';

  @override
  String get chaletTypeSuperior => 'Superior';

  @override
  String get chaletTypeVip => 'VIP';

  @override
  String get filterGuestsTitle => 'Guests';

  @override
  String get guestsLabel => 'Guests';

  @override
  String get guestsHint => 'Number of guests';

  @override
  String get guestsMinError => 'Guests must be at least 1.';

  @override
  String get filterPriceRangeTitle => 'Price Range';

  @override
  String get minPriceLabel => 'Minimum Price';

  @override
  String get maxPriceLabel => 'Maximum Price';

  @override
  String get priceRangeInvalid =>
      'Minimum price must be less than or equal to maximum price.';

  @override
  String get reset => 'Reset';

  @override
  String get search => 'Search';

  @override
  String get aboutThisChalet => 'About this chalet';

  @override
  String get showMore => 'Show more';

  @override
  String get showLess => 'Show less';

  @override
  String get amenities => 'Amenities';

  @override
  String get reserve => 'Reserve';

  @override
  String get detailsTitle => 'Details';

  @override
  String get masterRoomsLabel => 'Master Rooms';

  @override
  String get singleRoomsLabel => 'Single Rooms';

  @override
  String get maxGuestsLabel => 'Max Guests';

  @override
  String get bookingsOngoingTab => 'Ongoing';

  @override
  String get bookingsCompletedTab => 'Completed';

  @override
  String get bookingsCancelledTab => 'Canceled';

  @override
  String get bookingStatusPending => 'Pending';

  @override
  String get bookingStatusConfirmed => 'Confirmed';

  @override
  String get bookingStatusCheckedIn => 'Checked In';

  @override
  String get bookingStatusCompleted => 'Completed';

  @override
  String get bookingStatusCancelled => 'Cancelled';

  @override
  String get viewTicket => 'View Ticket';

  @override
  String get noBookingsYet => 'No bookings yet';

  @override
  String get noBookingsYetSubtitle => 'You haven\'t made any bookings yet.';

  @override
  String get exploreChalets => 'Explore Chalets';

  @override
  String get errorLoadingBookings =>
      'Something went wrong while loading your bookings.';

  @override
  String get bookingTicketTitle => 'Booking Ticket';

  @override
  String get bookingNumberLabel => 'Booking Number';

  @override
  String get bookingDetailsTitle => 'Booking Details';

  @override
  String get bookingInformationTitle => 'Booking Information';

  @override
  String get customerInformationTitle => 'Customer Information';

  @override
  String get customerNameLabel => 'Full Name';

  @override
  String get customerEmailLabel => 'Email';

  @override
  String get customerPhoneLabel => 'Phone';

  @override
  String get checkoutSummaryTitle => 'Checkout Summary';

  @override
  String get nightsLabel => 'Nights';

  @override
  String get guestCountLabel => 'Guests';

  @override
  String get baseAmountLabel => 'Base Amount';

  @override
  String get taxAmountLabel => 'Tax';

  @override
  String get addOnAmountLabel => 'Add-ons';

  @override
  String get discountAmountLabel => 'Discount';

  @override
  String get totalAmountLabel => 'Total';

  @override
  String get cancelReservation => 'Cancel Reservation';

  @override
  String get close => 'Close';

  @override
  String get bookingNotFoundTitle => 'Booking Not Found';

  @override
  String get bookingNotFoundSubtitle => 'We couldn\'t find this booking.';

  @override
  String get errorLoadingBookingDetails =>
      'We couldn\'t load this booking. Please try again.';

  @override
  String get cancelReservationSheetTitle => 'Cancel Reservation';

  @override
  String get cancelReservationReasonLabel => 'Reason for cancellation';

  @override
  String get cancelReservationReasonHint =>
      'Tell us why you\'re cancelling this booking...';

  @override
  String get cancelReasonRequired => 'Please enter a cancellation reason.';

  @override
  String get confirmCancellation => 'Confirm Cancellation';

  @override
  String get bookingPendingCancellationMessage =>
      'Your cancellation request is pending review.';

  @override
  String get errorCancelBooking =>
      'We couldn\'t cancel this booking. Please try again.';

  @override
  String get wishlistEmptyTitle => 'Your wishlist is empty';

  @override
  String get wishlistEmptySubtitle =>
      'Tap the heart icon on any chalet to save it here.';
}
