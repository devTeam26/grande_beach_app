import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @chooseYourLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseYourLanguage;

  /// No description provided for @languageChangeHint.
  ///
  /// In en, this message translates to:
  /// **'You can change the language later from settings.'**
  String get languageChangeHint;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to GrandeBeach'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDescription1.
  ///
  /// In en, this message translates to:
  /// **'Discover the finest chalets and resorts for your perfect getaway.'**
  String get onboardingDescription1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Easy Booking'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDescription2.
  ///
  /// In en, this message translates to:
  /// **'Book your stay in just a few taps with real-time availability.'**
  String get onboardingDescription2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Exclusive Rewards'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDescription3.
  ///
  /// In en, this message translates to:
  /// **'Earn loyalty points and enjoy special promotions on every booking.'**
  String get onboardingDescription3;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @loginToYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Login to your Account'**
  String get loginToYourAccount;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your Account'**
  String get createAccount;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @firstNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your first name'**
  String get firstNameHint;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @lastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your last name'**
  String get lastNameHint;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get phoneNumberHint;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get confirmPasswordHint;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully. Please sign in.'**
  String get registrationSuccess;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Your Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and choose a new password.'**
  String get forgotPasswordSubtitle;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @newPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get newPasswordHint;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @resetPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully. Please sign in.'**
  String get resetPasswordSuccess;

  /// No description provided for @errorTokenInvalid.
  ///
  /// In en, this message translates to:
  /// **'The reset token is invalid or has expired.'**
  String get errorTokenInvalid;

  /// Greeting shown on the home screen using the user first name
  ///
  /// In en, this message translates to:
  /// **'Hey, {firstName}👋'**
  String greeting(String firstName);

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get navDiscover;

  /// No description provided for @navBookings.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get navBookings;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @discoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discoverTitle;

  /// No description provided for @bookingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Bookings'**
  String get bookingsTitle;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @passwordRequirementsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your password must contain'**
  String get passwordRequirementsTitle;

  /// No description provided for @passwordReqMinLength.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get passwordReqMinLength;

  /// No description provided for @passwordReqUppercase.
  ///
  /// In en, this message translates to:
  /// **'One uppercase letter'**
  String get passwordReqUppercase;

  /// No description provided for @passwordReqLowercase.
  ///
  /// In en, this message translates to:
  /// **'One lowercase letter'**
  String get passwordReqLowercase;

  /// No description provided for @passwordReqNumber.
  ///
  /// In en, this message translates to:
  /// **'One number'**
  String get passwordReqNumber;

  /// No description provided for @passwordReqSpecialChar.
  ///
  /// In en, this message translates to:
  /// **'One special character'**
  String get passwordReqSpecialChar;

  /// No description provided for @errorEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required.'**
  String get errorEmailRequired;

  /// No description provided for @errorEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address.'**
  String get errorEmailInvalid;

  /// No description provided for @errorPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required.'**
  String get errorPasswordRequired;

  /// No description provided for @errorPasswordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get errorPasswordTooShort;

  /// No description provided for @errorPasswordRequirementsNotMet.
  ///
  /// In en, this message translates to:
  /// **'Password does not meet the requirements above.'**
  String get errorPasswordRequirementsNotMet;

  /// No description provided for @errorFirstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required.'**
  String get errorFirstNameRequired;

  /// No description provided for @errorLastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required.'**
  String get errorLastNameRequired;

  /// No description provided for @errorPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required.'**
  String get errorPhoneRequired;

  /// No description provided for @errorPhoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number.'**
  String get errorPhoneInvalid;

  /// No description provided for @errorConfirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password.'**
  String get errorConfirmPasswordRequired;

  /// No description provided for @errorPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get errorPasswordMismatch;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network and try again.'**
  String get errorNoInternet;

  /// No description provided for @errorServer.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong on our end. Please try again later.'**
  String get errorServer;

  /// No description provided for @errorUnknown.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get errorUnknown;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Unable to reach the server. Please try again.'**
  String get errorNetwork;

  /// No description provided for @noInternetTitle.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetTitle;

  /// No description provided for @noInternetMessage.
  ///
  /// In en, this message translates to:
  /// **'Please check your Wi-Fi or mobile data and try again.'**
  String get noInternetMessage;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @accountInformation.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformation;

  /// No description provided for @loyaltyPoints.
  ///
  /// In en, this message translates to:
  /// **'Loyalty Points'**
  String get loyaltyPoints;

  /// Formatted loyalty points value displayed in the profile
  ///
  /// In en, this message translates to:
  /// **'{points} pts'**
  String loyaltyPointsValue(String points);

  /// No description provided for @wishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlist;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @generalSettings.
  ///
  /// In en, this message translates to:
  /// **'General Settings'**
  String get generalSettings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmMessage;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @profileUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully.'**
  String get profileUpdatedSuccess;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @currentPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get currentPasswordHint;

  /// No description provided for @passwordChangedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully.'**
  String get passwordChangedSuccess;

  /// No description provided for @errorCurrentPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Current password is required.'**
  String get errorCurrentPasswordRequired;

  /// No description provided for @emailNotEditable.
  ///
  /// In en, this message translates to:
  /// **'Email address cannot be changed.'**
  String get emailNotEditable;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @popularChalets.
  ///
  /// In en, this message translates to:
  /// **'Popular Chalets'**
  String get popularChalets;

  /// No description provided for @recentlyAdded.
  ///
  /// In en, this message translates to:
  /// **'Recently Added'**
  String get recentlyAdded;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @exploreMore.
  ///
  /// In en, this message translates to:
  /// **'Explore More'**
  String get exploreMore;

  /// No description provided for @perNight.
  ///
  /// In en, this message translates to:
  /// **'/night'**
  String get perNight;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'reviews'**
  String get reviews;

  /// No description provided for @kwdCurrency.
  ///
  /// In en, this message translates to:
  /// **'KWD'**
  String get kwdCurrency;

  /// No description provided for @discoverSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Find your perfect luxury stay'**
  String get discoverSearchHint;

  /// No description provided for @discoverChaletsTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover Our Chalets'**
  String get discoverChaletsTitle;

  /// No description provided for @noChaletsFound.
  ///
  /// In en, this message translates to:
  /// **'No Chalets Found'**
  String get noChaletsFound;

  /// No description provided for @noChaletsFoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'There are currently no chalets available.'**
  String get noChaletsFoundSubtitle;

  /// No description provided for @errorLoadingChalets.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load the chalets. Please try again.'**
  String get errorLoadingChalets;

  /// No description provided for @reviewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviewsTitle;

  /// No description provided for @allReviewsFilter.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allReviewsFilter;

  /// No description provided for @noReviewsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Reviews Yet'**
  String get noReviewsTitle;

  /// No description provided for @noReviewsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This chalet hasn\'t received any reviews yet.'**
  String get noReviewsSubtitle;

  /// No description provided for @errorLoadingReviews.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load the reviews. Please try again.'**
  String get errorLoadingReviews;

  /// No description provided for @searchSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Find Your Perfect Chalet'**
  String get searchSheetTitle;

  /// No description provided for @searchSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose one or more filters to discover the perfect stay.'**
  String get searchSheetSubtitle;

  /// No description provided for @filterWhenTitle.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get filterWhenTitle;

  /// No description provided for @checkInLabel.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get checkInLabel;

  /// No description provided for @checkOutLabel.
  ///
  /// In en, this message translates to:
  /// **'Check-out'**
  String get checkOutLabel;

  /// No description provided for @filterChaletTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Chalet Type'**
  String get filterChaletTypeTitle;

  /// No description provided for @chaletTypeStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get chaletTypeStandard;

  /// No description provided for @chaletTypeSuperior.
  ///
  /// In en, this message translates to:
  /// **'Superior'**
  String get chaletTypeSuperior;

  /// No description provided for @chaletTypeVip.
  ///
  /// In en, this message translates to:
  /// **'VIP'**
  String get chaletTypeVip;

  /// No description provided for @filterGuestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get filterGuestsTitle;

  /// No description provided for @guestsLabel.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get guestsLabel;

  /// No description provided for @guestsHint.
  ///
  /// In en, this message translates to:
  /// **'Number of guests'**
  String get guestsHint;

  /// No description provided for @guestsMinError.
  ///
  /// In en, this message translates to:
  /// **'Guests must be at least 1.'**
  String get guestsMinError;

  /// No description provided for @filterPriceRangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get filterPriceRangeTitle;

  /// No description provided for @minPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Minimum Price'**
  String get minPriceLabel;

  /// No description provided for @maxPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Maximum Price'**
  String get maxPriceLabel;

  /// No description provided for @priceRangeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Minimum price must be less than or equal to maximum price.'**
  String get priceRangeInvalid;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @aboutThisChalet.
  ///
  /// In en, this message translates to:
  /// **'About this chalet'**
  String get aboutThisChalet;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get showMore;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get showLess;

  /// No description provided for @amenities.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get amenities;

  /// No description provided for @reserve.
  ///
  /// In en, this message translates to:
  /// **'Reserve'**
  String get reserve;

  /// No description provided for @detailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsTitle;

  /// No description provided for @masterRoomsLabel.
  ///
  /// In en, this message translates to:
  /// **'Master Rooms'**
  String get masterRoomsLabel;

  /// No description provided for @singleRoomsLabel.
  ///
  /// In en, this message translates to:
  /// **'Single Rooms'**
  String get singleRoomsLabel;

  /// No description provided for @maxGuestsLabel.
  ///
  /// In en, this message translates to:
  /// **'Max Guests'**
  String get maxGuestsLabel;

  /// No description provided for @bathroomsLabel.
  ///
  /// In en, this message translates to:
  /// **'Bathrooms'**
  String get bathroomsLabel;

  /// No description provided for @servantRoomLabel.
  ///
  /// In en, this message translates to:
  /// **'Servant Room'**
  String get servantRoomLabel;

  /// No description provided for @bookingsOngoingTab.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get bookingsOngoingTab;

  /// No description provided for @bookingsCompletedTab.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get bookingsCompletedTab;

  /// No description provided for @bookingsCancelledTab.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get bookingsCancelledTab;

  /// No description provided for @bookingsRejectedTab.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get bookingsRejectedTab;

  /// No description provided for @bookingStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get bookingStatusPending;

  /// No description provided for @bookingStatusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get bookingStatusConfirmed;

  /// No description provided for @bookingStatusCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Checked In'**
  String get bookingStatusCheckedIn;

  /// No description provided for @bookingStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get bookingStatusCompleted;

  /// No description provided for @bookingStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get bookingStatusCancelled;

  /// No description provided for @bookingStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get bookingStatusRejected;

  /// No description provided for @viewTicket.
  ///
  /// In en, this message translates to:
  /// **'View Ticket'**
  String get viewTicket;

  /// No description provided for @verifyButton.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyButton;

  /// No description provided for @verificationScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Verification'**
  String get verificationScreenTitle;

  /// No description provided for @verificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload the required documents so we can confirm your booking.'**
  String get verificationSubtitle;

  /// No description provided for @verificationUnderReviewMessage.
  ///
  /// In en, this message translates to:
  /// **'Your verification request is currently under review.'**
  String get verificationUnderReviewMessage;

  /// Warning shown before the upload form when the user's previous verification was rejected
  ///
  /// In en, this message translates to:
  /// **'Your previous verification request was rejected.\nReason: \"{reason}\"\n\nPlease review the reason above, update your documents if necessary, and submit them again.'**
  String verificationRejectedMessage(String reason);

  /// No description provided for @idCardTitle.
  ///
  /// In en, this message translates to:
  /// **'ID Card'**
  String get idCardTitle;

  /// No description provided for @idCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload one image that clearly contains both the front and back sides of your ID card.'**
  String get idCardSubtitle;

  /// No description provided for @personalPhotoTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Photo'**
  String get personalPhotoTitle;

  /// No description provided for @personalPhotoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload a clear selfie for identity verification.'**
  String get personalPhotoSubtitle;

  /// No description provided for @digitalSignatureTitle.
  ///
  /// In en, this message translates to:
  /// **'Digital Signature'**
  String get digitalSignatureTitle;

  /// No description provided for @digitalSignatureSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign using your finger below.'**
  String get digitalSignatureSubtitle;

  /// No description provided for @uploadImageButton.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImageButton;

  /// No description provided for @replaceImageButton.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get replaceImageButton;

  /// No description provided for @removeImageButton.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeImageButton;

  /// No description provided for @clearSignatureButton.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearSignatureButton;

  /// No description provided for @undoSignatureButton.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undoSignatureButton;

  /// No description provided for @takePhotoOption.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhotoOption;

  /// No description provided for @chooseFromGalleryOption.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGalleryOption;

  /// No description provided for @cameraPermissionDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera Access Needed'**
  String get cameraPermissionDeniedTitle;

  /// No description provided for @cameraPermissionDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'Grande Beach needs camera access to take this photo. Please allow it in your device settings.'**
  String get cameraPermissionDeniedMessage;

  /// No description provided for @openSettingsButton.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettingsButton;

  /// No description provided for @submitVerificationButton.
  ///
  /// In en, this message translates to:
  /// **'Submit for Review'**
  String get submitVerificationButton;

  /// No description provided for @verificationIncompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Please upload your ID card, personal photo, and signature to continue.'**
  String get verificationIncompleteMessage;

  /// No description provided for @verificationSubmittedTitle.
  ///
  /// In en, this message translates to:
  /// **'Verification Submitted'**
  String get verificationSubmittedTitle;

  /// No description provided for @verificationSubmittedMessage.
  ///
  /// In en, this message translates to:
  /// **'Thank you! Your documents have been submitted successfully. Our team is reviewing them and will confirm your booking as soon as it\'s approved.'**
  String get verificationSubmittedMessage;

  /// No description provided for @verificationErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Submission Failed'**
  String get verificationErrorTitle;

  /// No description provided for @errorSubmittingVerification.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t submit your verification. Please try again.'**
  String get errorSubmittingVerification;

  /// No description provided for @noBookingsYet.
  ///
  /// In en, this message translates to:
  /// **'No bookings yet'**
  String get noBookingsYet;

  /// No description provided for @noBookingsYetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t made any bookings yet.'**
  String get noBookingsYetSubtitle;

  /// No description provided for @exploreChalets.
  ///
  /// In en, this message translates to:
  /// **'Explore Chalets'**
  String get exploreChalets;

  /// No description provided for @errorLoadingBookings.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while loading your bookings.'**
  String get errorLoadingBookings;

  /// No description provided for @bookingTicketTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Ticket'**
  String get bookingTicketTitle;

  /// No description provided for @bookingNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Booking Number'**
  String get bookingNumberLabel;

  /// No description provided for @bookingDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetailsTitle;

  /// No description provided for @bookingInformationTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Information'**
  String get bookingInformationTitle;

  /// No description provided for @customerInformationTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer Information'**
  String get customerInformationTitle;

  /// No description provided for @customerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get customerNameLabel;

  /// No description provided for @customerEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get customerEmailLabel;

  /// No description provided for @customerPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get customerPhoneLabel;

  /// No description provided for @checkoutSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout Summary'**
  String get checkoutSummaryTitle;

  /// No description provided for @nightsLabel.
  ///
  /// In en, this message translates to:
  /// **'Nights'**
  String get nightsLabel;

  /// No description provided for @guestCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get guestCountLabel;

  /// No description provided for @baseAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Base Amount (per night)'**
  String get baseAmountLabel;

  /// No description provided for @taxAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get taxAmountLabel;

  /// No description provided for @addOnAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Add-ons'**
  String get addOnAmountLabel;

  /// No description provided for @discountAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discountAmountLabel;

  /// No description provided for @totalAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalAmountLabel;

  /// No description provided for @cancelReservation.
  ///
  /// In en, this message translates to:
  /// **'Cancel Reservation'**
  String get cancelReservation;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @bookingNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Not Found'**
  String get bookingNotFoundTitle;

  /// No description provided for @bookingNotFoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find this booking.'**
  String get bookingNotFoundSubtitle;

  /// No description provided for @errorLoadingBookingDetails.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load this booking. Please try again.'**
  String get errorLoadingBookingDetails;

  /// No description provided for @cancelReservationSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Reservation'**
  String get cancelReservationSheetTitle;

  /// No description provided for @cancelReservationReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason for cancellation'**
  String get cancelReservationReasonLabel;

  /// No description provided for @cancelReservationReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us why you\'re cancelling this booking...'**
  String get cancelReservationReasonHint;

  /// No description provided for @cancelReasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a cancellation reason.'**
  String get cancelReasonRequired;

  /// No description provided for @confirmCancellation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Cancellation'**
  String get confirmCancellation;

  /// No description provided for @bookingPendingCancellationMessage.
  ///
  /// In en, this message translates to:
  /// **'Your cancellation request is pending review.'**
  String get bookingPendingCancellationMessage;

  /// No description provided for @errorCancelBooking.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t cancel this booking. Please try again.'**
  String get errorCancelBooking;

  /// No description provided for @cancellationReasonTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Reason'**
  String get cancellationReasonTitle;

  /// No description provided for @writeReviewButton.
  ///
  /// In en, this message translates to:
  /// **'Write a Review'**
  String get writeReviewButton;

  /// No description provided for @submitReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Rate Your Stay'**
  String get submitReviewTitle;

  /// No description provided for @submitReviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your experience to help other guests.'**
  String get submitReviewSubtitle;

  /// No description provided for @reviewCommentLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Review'**
  String get reviewCommentLabel;

  /// No description provided for @reviewCommentHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your stay...'**
  String get reviewCommentHint;

  /// No description provided for @submitReviewButton.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submitReviewButton;

  /// No description provided for @ratingRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please select a rating.'**
  String get ratingRequiredError;

  /// No description provided for @reviewCommentRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Please write a comment.'**
  String get reviewCommentRequiredError;

  /// No description provided for @reviewSubmittedMessage.
  ///
  /// In en, this message translates to:
  /// **'Thank you! Your review has been submitted.'**
  String get reviewSubmittedMessage;

  /// No description provided for @errorSubmittingReview.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t submit your review. Please try again.'**
  String get errorSubmittingReview;

  /// No description provided for @wishlistEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your wishlist is empty'**
  String get wishlistEmptyTitle;

  /// No description provided for @wishlistEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart icon on any chalet to save it here.'**
  String get wishlistEmptySubtitle;

  /// No description provided for @reservationTitle.
  ///
  /// In en, this message translates to:
  /// **'Reserve'**
  String get reservationTitle;

  /// No description provided for @errorLoadingAvailability.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load availability for this month. Please try again.'**
  String get errorLoadingAvailability;

  /// No description provided for @selectedRangeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'These dates aren\'t available. Please choose an available range.'**
  String get selectedRangeUnavailable;

  /// No description provided for @reservationStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Select Dates'**
  String get reservationStep1Title;

  /// No description provided for @reservationStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Choose Add-ons'**
  String get reservationStep2Title;

  /// No description provided for @reservationStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Price Preview'**
  String get reservationStep3Title;

  /// Shown when the guest count exceeds a chalet's maxGuests
  ///
  /// In en, this message translates to:
  /// **'Maximum guests allowed is {max}.'**
  String guestCountMaxError(String max);

  /// Price badge for an add-on billed per night
  ///
  /// In en, this message translates to:
  /// **'{price}/night'**
  String addOnPerNightBadge(String price);

  /// Price badge for a one-time add-on
  ///
  /// In en, this message translates to:
  /// **'{price}'**
  String addOnFlatPriceBadge(String price);

  /// No description provided for @weekendPricingNote.
  ///
  /// In en, this message translates to:
  /// **'Weekend nights may be priced differently from weekdays.'**
  String get weekendPricingNote;

  /// No description provided for @addOnsListSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enhance your stay with these optional extras.'**
  String get addOnsListSubtitle;

  /// No description provided for @noAddOnsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Add-ons Available'**
  String get noAddOnsTitle;

  /// No description provided for @noAddOnsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This chalet has no optional add-ons to choose from.'**
  String get noAddOnsSubtitle;

  /// No description provided for @errorLoadingAddOns.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load the add-ons. Please try again.'**
  String get errorLoadingAddOns;

  /// No description provided for @errorLoadingPricePreview.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t load the price preview. Please try again.'**
  String get errorLoadingPricePreview;

  /// No description provided for @priceBreakdownTitle.
  ///
  /// In en, this message translates to:
  /// **'Price Breakdown'**
  String get priceBreakdownTitle;

  /// No description provided for @backToHomeButton.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHomeButton;

  /// No description provided for @nextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// No description provided for @backButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButton;

  /// No description provided for @bookingSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Reservation Submitted'**
  String get bookingSuccessTitle;

  /// No description provided for @bookingSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'We are looking into your reservation. Our customer support will contact you once the reservation is confirmed.'**
  String get bookingSuccessMessage;

  /// No description provided for @bookingErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Reservation Failed'**
  String get bookingErrorTitle;

  /// No description provided for @errorSubmittingBooking.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t submit your reservation. Please try again.'**
  String get errorSubmittingBooking;

  /// No description provided for @tryAgainButton.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgainButton;

  /// No description provided for @whatsappSupportMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello, I need assistance with GrandeBeach Khairan.'**
  String get whatsappSupportMessage;

  /// WhatsApp prefilled message for a chalet inquiry from the Chalet Details screen
  ///
  /// In en, this message translates to:
  /// **'Hello,\nI\'d like to ask about this chalet\'s details.\n\nChalet:\n{chaletName}\n\nThank you.'**
  String whatsappChaletInquiryMessage(String chaletName);

  /// WhatsApp prefilled message for a chalet inquiry from the Chalet Details screen
  ///
  /// In en, this message translates to:
  /// **'Hello,\nI\'d like to ask about this chalet\'s cancellation policy.\n\nChalet:\n{chaletName}\n\nThank you.'**
  String whatsappChaletCancelationPolicyInquiryMessage(String chaletName);

  /// No description provided for @whatsappBookingSupportMessage.
  ///
  /// In en, this message translates to:
  /// **'Hello,\nI need help with my booking at GrandeBeach Khairan.\n\nThank you.'**
  String get whatsappBookingSupportMessage;

  /// WhatsApp prefilled message for a booking inquiry, including the booking number
  ///
  /// In en, this message translates to:
  /// **'Hello,\nI need help with my booking at GrandeBeach Khairan.\n\nBooking Number:\n{bookingNumber}\n\nMy inquiry:\n____________________\n\nThank you.'**
  String whatsappBookingSupportMessageWithNumber(String bookingNumber);

  /// No description provided for @specialRequestLabel.
  ///
  /// In en, this message translates to:
  /// **'Special Request (optional)'**
  String get specialRequestLabel;

  /// No description provided for @specialRequestHint.
  ///
  /// In en, this message translates to:
  /// **'Anything you\'d like us to know? (e.g. early check-in)'**
  String get specialRequestHint;

  /// No description provided for @cancellationPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Policy'**
  String get cancellationPolicyTitle;

  /// No description provided for @cancellationPolicyContactMessage.
  ///
  /// In en, this message translates to:
  /// **'If you\'d like to ask about the cancellation policy for this chalet, please contact us on WhatsApp.'**
  String get cancellationPolicyContactMessage;

  /// No description provided for @contactUsOnWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'Contact us on WhatsApp'**
  String get contactUsOnWhatsapp;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
