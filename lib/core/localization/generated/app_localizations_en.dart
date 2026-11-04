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
      'Enter the email address associated with your Grande Beach account and we\'ll send you a link to reset your password.';

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
  String get forgotPasswordCheckEmailHint =>
      'After confirming, check your inbox for the reset email. If you can\'t find it, check your spam folder.';

  @override
  String get resetEmailSent => 'A password reset email has been sent.';

  @override
  String get checkInboxAndSpam => 'Please check your inbox and spam folder.';

  @override
  String get orLabel => 'OR';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get googleSignInCancelled => 'Google sign-in was cancelled.';

  @override
  String get googleSignInFailed => 'Google sign-in failed. Please try again.';

  @override
  String get googleSignInUnavailable =>
      'Unable to sign in with Google. Please try again later.';

  @override
  String greeting(String firstName) {
    return 'Hey, $firstName👋';
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
  String get errorKuwaitPhoneInvalid =>
      'Please enter a valid 8-digit Kuwaiti phone number.';

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
  String get deleteAccount => 'Delete Account';

  @override
  String get deleteAccountConfirmTitle => 'Delete your account?';

  @override
  String get deleteAccountConfirmMessage =>
      'This action is permanent and cannot be undone. If you continue, your account and all of your data will be permanently removed.';

  @override
  String get deleteAccountConfirm => 'Delete';

  @override
  String get accountDeletedSuccess => 'Your account has been deleted.';

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
  String get reviewsTitle => 'Reviews';

  @override
  String get guestReviewsTitle => 'Guest Reviews';

  @override
  String get allReviewsFilter => 'All';

  @override
  String get noReviewsTitle => 'No Reviews Yet';

  @override
  String get noReviewsSubtitle =>
      'This chalet hasn\'t received any reviews yet.';

  @override
  String get errorLoadingReviews =>
      'We couldn\'t load the reviews. Please try again.';

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
  String get bathroomsLabel => 'Bathrooms';

  @override
  String get servantRoomLabel => 'Servant Room';

  @override
  String get bookingsOngoingTab => 'Ongoing';

  @override
  String get bookingsCompletedTab => 'Completed';

  @override
  String get bookingsCancelledTab => 'Cancelled';

  @override
  String get bookingsRejectedTab => 'Rejected';

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
  String get bookingStatusRejected => 'Rejected';

  @override
  String get viewTicket => 'View Ticket';

  @override
  String get verifyButton => 'Verify';

  @override
  String get verificationScreenTitle => 'Booking Verification';

  @override
  String get verificationSubtitle =>
      'Upload the required documents so we can confirm your booking.';

  @override
  String get verificationUnderReviewMessage =>
      'Your verification request is currently under review.';

  @override
  String get bookingRequestUnderReviewMessage =>
      'Your request is under review by our team.';

  @override
  String verificationRejectedMessage(String reason) {
    return 'Your previous verification request was rejected.\nReason: \"$reason\"\n\nPlease review the reason above, update your documents if necessary, and submit them again.';
  }

  @override
  String get idCardTitle => 'ID Card';

  @override
  String get idCardSubtitle =>
      'Upload one image that clearly contains both the front and back sides of your ID card.';

  @override
  String get personalPhotoTitle => 'Personal Photo';

  @override
  String get personalPhotoSubtitle =>
      'Upload a clear selfie for identity verification.';

  @override
  String get digitalSignatureTitle => 'Digital Signature';

  @override
  String get digitalSignatureSubtitle => 'Sign using your finger below.';

  @override
  String get uploadImageButton => 'Upload Image';

  @override
  String get replaceImageButton => 'Replace';

  @override
  String get removeImageButton => 'Remove';

  @override
  String get clearSignatureButton => 'Clear';

  @override
  String get undoSignatureButton => 'Undo';

  @override
  String get takePhotoOption => 'Take Photo';

  @override
  String get chooseFromGalleryOption => 'Choose from Gallery';

  @override
  String get cameraPermissionDeniedTitle => 'Camera Access Needed';

  @override
  String get cameraPermissionDeniedMessage =>
      'Grande Beach needs camera access to take this photo. Please allow it in your device settings.';

  @override
  String get openSettingsButton => 'Open Settings';

  @override
  String get submitVerificationButton => 'Submit for Review';

  @override
  String get verificationIncompleteMessage =>
      'Please upload your ID card, personal photo, and signature to continue.';

  @override
  String get verificationSubmittedTitle => 'Verification Submitted';

  @override
  String get verificationSubmittedMessage =>
      'Thank you! Your documents have been submitted successfully. Our team is reviewing them and will confirm your booking as soon as it\'s approved.';

  @override
  String get verificationErrorTitle => 'Submission Failed';

  @override
  String get errorSubmittingVerification =>
      'We couldn\'t submit your verification. Please try again.';

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
  String get baseAmountLabel => 'Base Amount (per night)';

  @override
  String get taxAmountLabel => 'Tax';

  @override
  String get addOnAmountLabel => 'Add-ons';

  @override
  String get addOnsSubtotalLabel => 'Add-ons Total';

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
  String get cancellationReasonTitle => 'Cancellation Reason';

  @override
  String get writeReviewButton => 'Write a Review';

  @override
  String get submitReviewTitle => 'Rate Your Stay';

  @override
  String get submitReviewSubtitle =>
      'Share your experience to help other guests.';

  @override
  String get reviewCommentLabel => 'Your Review';

  @override
  String get reviewCommentHint => 'Tell us about your stay...';

  @override
  String get submitReviewButton => 'Submit Review';

  @override
  String get ratingRequiredError => 'Please select a rating.';

  @override
  String get reviewCommentRequiredError => 'Please write a comment.';

  @override
  String get reviewSubmittedMessage =>
      'Thank you! Your review has been submitted.';

  @override
  String get errorSubmittingReview =>
      'We couldn\'t submit your review. Please try again.';

  @override
  String get wishlistEmptyTitle => 'Your wishlist is empty';

  @override
  String get wishlistEmptySubtitle =>
      'Tap the heart icon on any chalet to save it here.';

  @override
  String get reservationTitle => 'Reserve';

  @override
  String get errorLoadingAvailability =>
      'We couldn\'t load availability for this month. Please try again.';

  @override
  String get selectedRangeUnavailable =>
      'These dates aren\'t available. Please choose an available range.';

  @override
  String get reservationStep1Title => 'Select Dates';

  @override
  String get reservationStep2Title => 'Choose Add-ons';

  @override
  String get reservationStep3Title => 'Price Preview';

  @override
  String guestCountMaxError(String max) {
    return 'Maximum guests allowed is $max.';
  }

  @override
  String addOnPerNightBadge(String price) {
    return '$price/night';
  }

  @override
  String addOnFlatPriceBadge(String price) {
    return '$price';
  }

  @override
  String get weekendPricingNote =>
      'Weekend nights may be priced differently from weekdays.';

  @override
  String get basePriceNoteTitle => 'Base price • ';

  @override
  String get basePriceNote => 'weekend/seasonal rates apply';

  @override
  String get addOnsListSubtitle =>
      'Enhance your stay with these optional extras.';

  @override
  String get noAddOnsTitle => 'No Add-ons Available';

  @override
  String get noAddOnsSubtitle =>
      'This chalet has no optional add-ons to choose from.';

  @override
  String get errorLoadingAddOns =>
      'We couldn\'t load the add-ons. Please try again.';

  @override
  String get errorLoadingPricePreview =>
      'We couldn\'t load the price preview. Please try again.';

  @override
  String get priceBreakdownTitle => 'Price Breakdown';

  @override
  String get backToHomeButton => 'Back to Home';

  @override
  String get nextButton => 'Next';

  @override
  String get backButton => 'Back';

  @override
  String get bookingSuccessTitle => 'Reservation Submitted';

  @override
  String get bookingSuccessMessage =>
      'We are looking into your reservation. Our customer support will contact you once the reservation is confirmed.';

  @override
  String get bookingErrorTitle => 'Reservation Failed';

  @override
  String get errorSubmittingBooking =>
      'We couldn\'t submit your reservation. Please try again.';

  @override
  String get tryAgainButton => 'Try Again';

  @override
  String get whatsappSupportMessage =>
      'Hello, I need assistance with GrandeBeach Khairan.';

  @override
  String whatsappChaletInquiryMessage(String chaletName) {
    return 'Hello,\nI\'d like to ask about this chalet\'s details.\n\nChalet:\n$chaletName\n\nThank you.';
  }

  @override
  String whatsappChaletCancelationPolicyInquiryMessage(String chaletName) {
    return 'Hello,\nI\'d like to ask about this chalet\'s cancellation policy.\n\nChalet:\n$chaletName\n\nThank you.';
  }

  @override
  String get whatsappBookingSupportMessage =>
      'Hello,\nI need help with my booking at GrandeBeach Khairan.\n\nThank you.';

  @override
  String whatsappBookingSupportMessageWithNumber(String bookingNumber) {
    return 'Hello,\nI need help with my booking at GrandeBeach Khairan.\n\nBooking Number:\n$bookingNumber\n\nMy inquiry:\n____________________\n\nThank you.';
  }

  @override
  String get specialRequestLabel => 'Special Request (optional)';

  @override
  String get specialRequestHint =>
      'Anything you\'d like us to know? (e.g. early check-in)';

  @override
  String get cancellationPolicyTitle => 'Cancellation Policy';

  @override
  String get cancellationPolicyContactMessage =>
      'If you\'d like to ask about the cancellation policy for this chalet, please contact us on WhatsApp.';

  @override
  String get contactUsOnWhatsapp => 'Contact us on WhatsApp';

  @override
  String get guestUser => 'Guest User';

  @override
  String get login => 'Login';

  @override
  String get loginRequiredTitle => 'Login Required';

  @override
  String get signInToViewBookings =>
      'You need to sign in to view your bookings.';

  @override
  String get signInToCompleteReservation =>
      'You need to sign in to complete your reservation.';

  @override
  String get guest => 'Guest';
}
