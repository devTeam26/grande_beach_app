// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get chooseYourLanguage => 'اختر لغتك';

  @override
  String get languageChangeHint => 'يمكنك تغيير اللغة لاحقًا من الإعدادات.';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get continueLabel => 'استمرار';

  @override
  String get onboardingTitle1 => 'مرحبًا بك في غراند بيتش';

  @override
  String get onboardingDescription1 =>
      'اكتشف أفضل الشاليهات والمنتجعات لإجازتك المثالية.';

  @override
  String get onboardingTitle2 => 'حجز سهل';

  @override
  String get onboardingDescription2 =>
      'احجز إقامتك بضغطات قليلة مع توفر فوري للحجز.';

  @override
  String get onboardingTitle3 => 'مكافآت حصرية';

  @override
  String get onboardingDescription3 =>
      'اكسب نقاط الولاء واستفد من العروض الخاصة مع كل حجز.';

  @override
  String get next => 'التالي';

  @override
  String get getStarted => 'ابدأ الآن';

  @override
  String get skip => 'تخطي';

  @override
  String get loginToYourAccount => 'تسجيل الدخول إلى حسابك';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get emailHint => 'أدخل بريدك الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordHint => 'أدخل كلمة المرور';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get createAccount => 'إنشاء حسابك';

  @override
  String get firstName => 'الاسم الأول';

  @override
  String get firstNameHint => 'أدخل اسمك الأول';

  @override
  String get lastName => 'اسم العائلة';

  @override
  String get lastNameHint => 'أدخل اسم العائلة';

  @override
  String get phoneNumber => 'رقم الهاتف';

  @override
  String get phoneNumberHint => 'أدخل رقم هاتفك';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get confirmPasswordHint => 'أعد إدخال كلمة المرور';

  @override
  String get alreadyHaveAccount => 'هل لديك حساب؟';

  @override
  String get registrationSuccess => 'تم إنشاء الحساب بنجاح. يرجى تسجيل الدخول.';

  @override
  String get forgotPasswordTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get forgotPasswordSubtitle =>
      'أدخل بريدك الإلكتروني واختر كلمة مرور جديدة.';

  @override
  String get newPassword => 'كلمة المرور الجديدة';

  @override
  String get newPasswordHint => 'أدخل كلمة المرور الجديدة';

  @override
  String get confirm => 'تأكيد';

  @override
  String get resetPasswordSuccess =>
      'تم إعادة تعيين كلمة المرور بنجاح. يرجى تسجيل الدخول.';

  @override
  String get errorTokenInvalid =>
      'رمز إعادة التعيين غير صالح أو منتهي الصلاحية.';

  @override
  String greeting(String firstName) {
    return 'مرحبًا، $firstName👋';
  }

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navDiscover => 'استكشاف';

  @override
  String get navBookings => 'الحجوزات';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get discoverTitle => 'استكشاف';

  @override
  String get bookingsTitle => 'الحجوزات';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get passwordRequirementsTitle => 'يجب أن تحتوي كلمة المرور على';

  @override
  String get passwordReqMinLength => '8 أحرف على الأقل';

  @override
  String get passwordReqUppercase => 'حرف كبير واحد';

  @override
  String get passwordReqLowercase => 'حرف صغير واحد';

  @override
  String get passwordReqNumber => 'رقم واحد';

  @override
  String get passwordReqSpecialChar => 'رمز خاص واحد';

  @override
  String get errorEmailRequired => 'البريد الإلكتروني مطلوب.';

  @override
  String get errorEmailInvalid => 'يرجى إدخال بريد إلكتروني صحيح.';

  @override
  String get errorPasswordRequired => 'كلمة المرور مطلوبة.';

  @override
  String get errorPasswordTooShort =>
      'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل.';

  @override
  String get errorPasswordRequirementsNotMet =>
      'كلمة المرور لا تستوفي الشروط المذكورة أعلاه.';

  @override
  String get errorFirstNameRequired => 'الاسم الأول مطلوب.';

  @override
  String get errorLastNameRequired => 'اسم العائلة مطلوب.';

  @override
  String get errorPhoneRequired => 'رقم الهاتف مطلوب.';

  @override
  String get errorPhoneInvalid => 'يرجى إدخال رقم هاتف صحيح.';

  @override
  String get errorConfirmPasswordRequired => 'يرجى تأكيد كلمة المرور.';

  @override
  String get errorPasswordMismatch => 'كلمتا المرور غير متطابقتين.';

  @override
  String get errorInvalidCredentials => 'بيانات تسجيل الدخول غير صحيحة.';

  @override
  String get errorNoInternet =>
      'لا يوجد اتصال بالإنترنت. يرجى التحقق من الشبكة والمحاولة مرة أخرى.';

  @override
  String get errorServer => 'حدث خطأ من جانبنا. يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get errorUnknown => 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';

  @override
  String get errorNetwork => 'تعذر الوصول إلى الخادم. يرجى المحاولة مرة أخرى.';

  @override
  String get noInternetTitle => 'لا يوجد اتصال بالإنترنت';

  @override
  String get noInternetMessage =>
      'يرجى التحقق من شبكة الواي فاي أو بيانات الجوال والمحاولة مرة أخرى.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get comingSoon => 'قريبًا';

  @override
  String get personalInformation => 'المعلومات الشخصية';

  @override
  String get accountInformation => 'معلومات الحساب';

  @override
  String get loyaltyPoints => 'نقاط الولاء';

  @override
  String loyaltyPointsValue(String points) {
    return '$points نقطة';
  }

  @override
  String get wishlist => 'قائمة الرغبات';

  @override
  String get paymentMethods => 'طرق الدفع';

  @override
  String get changePassword => 'تغيير كلمة المرور';

  @override
  String get generalSettings => 'الإعدادات العامة';

  @override
  String get language => 'اللغة';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutConfirmTitle => 'تسجيل الخروج';

  @override
  String get logoutConfirmMessage => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get logoutConfirm => 'تسجيل الخروج';

  @override
  String get cancel => 'إلغاء';

  @override
  String get edit => 'تعديل';

  @override
  String get from => 'من';

  @override
  String get to => 'إلى';

  @override
  String get save => 'حفظ';

  @override
  String get profileUpdatedSuccess => 'تم تحديث الملف الشخصي بنجاح.';

  @override
  String get currentPassword => 'كلمة المرور الحالية';

  @override
  String get currentPasswordHint => 'أدخل كلمة المرور الحالية';

  @override
  String get passwordChangedSuccess => 'تم تغيير كلمة المرور بنجاح.';

  @override
  String get errorCurrentPasswordRequired => 'كلمة المرور الحالية مطلوبة.';

  @override
  String get emailNotEditable => 'لا يمكن تغيير عنوان البريد الإلكتروني.';

  @override
  String get privacyPolicyTitle => 'سياسة الخصوصية';

  @override
  String get popularChalets => 'الشاليهات الشهيرة';

  @override
  String get recentlyAdded => 'المضافة حديثاً';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get exploreMore => 'استكشف المزيد';

  @override
  String get perNight => '/ليلة';

  @override
  String get reviews => 'تقييم';

  @override
  String get kwdCurrency => 'د.ك';

  @override
  String get discoverSearchHint => ' اعثر على إقامتك  المثالية';

  @override
  String get discoverChaletsTitle => 'اكتشف شاليهاتنا';

  @override
  String get noChaletsFound => 'لا توجد شاليهات';

  @override
  String get noChaletsFoundSubtitle => 'لا توجد شاليهات متاحة حالياً.';

  @override
  String get errorLoadingChalets =>
      'تعذر تحميل الشاليهات. يرجى المحاولة مرة أخرى.';

  @override
  String get reviewsTitle => 'التقييمات';

  @override
  String get allReviewsFilter => 'الكل';

  @override
  String get noReviewsTitle => 'لا توجد تقييمات بعد';

  @override
  String get noReviewsSubtitle => 'لم يحصل هذا الشاليه على أي تقييمات بعد.';

  @override
  String get errorLoadingReviews =>
      'تعذر تحميل التقييمات. يرجى المحاولة مرة أخرى.';

  @override
  String get searchSheetTitle => 'ابحث عن شاليهك المثالي';

  @override
  String get searchSheetSubtitle =>
      'اختر فلترًا واحدًا أو أكثر لاكتشاف الإقامة المثالية.';

  @override
  String get filterWhenTitle => 'التاريخ';

  @override
  String get checkInLabel => 'تسجيل الوصول';

  @override
  String get checkOutLabel => 'تسجيل المغادرة';

  @override
  String get filterChaletTypeTitle => 'نوع الشاليه';

  @override
  String get chaletTypeStandard => 'عادي';

  @override
  String get chaletTypeSuperior => 'متميز';

  @override
  String get chaletTypeVip => 'VIP';

  @override
  String get filterGuestsTitle => 'الضيوف';

  @override
  String get guestsLabel => 'الضيوف';

  @override
  String get guestsHint => 'عدد الضيوف';

  @override
  String get guestsMinError => 'يجب أن يكون عدد الضيوف 1 على الأقل.';

  @override
  String get filterPriceRangeTitle => 'نطاق السعر';

  @override
  String get minPriceLabel => 'الحد الأدنى للسعر';

  @override
  String get maxPriceLabel => 'الحد الأقصى للسعر';

  @override
  String get priceRangeInvalid =>
      'يجب أن يكون الحد الأدنى للسعر أقل من أو يساوي الحد الأقصى.';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get search => 'بحث';

  @override
  String get aboutThisChalet => 'عن هذا الشاليه';

  @override
  String get showMore => 'عرض المزيد';

  @override
  String get showLess => 'عرض أقل';

  @override
  String get amenities => 'المرافق';

  @override
  String get reserve => 'احجز الآن';

  @override
  String get detailsTitle => 'التفاصيل';

  @override
  String get masterRoomsLabel => 'غرف رئيسية';

  @override
  String get singleRoomsLabel => 'غرف فردية';

  @override
  String get maxGuestsLabel => 'الحد الأقصى للضيوف';

  @override
  String get bathroomsLabel => 'حمامات';

  @override
  String get servantRoomLabel => 'غرفة خادمة';

  @override
  String get bookingsOngoingTab => 'جارية';

  @override
  String get bookingsCompletedTab => 'مكتملة';

  @override
  String get bookingsCancelledTab => 'ملغاة';

  @override
  String get bookingsRejectedTab => 'مرفوضة';

  @override
  String get bookingStatusPending => 'قيد الانتظار';

  @override
  String get bookingStatusConfirmed => 'مؤكد';

  @override
  String get bookingStatusCheckedIn => 'تم تسجيل الوصول';

  @override
  String get bookingStatusCompleted => 'مكتمل';

  @override
  String get bookingStatusCancelled => 'ملغى';

  @override
  String get bookingStatusRejected => 'مرفوض';

  @override
  String get viewTicket => 'عرض التذكرة';

  @override
  String get verifyButton => 'توثيق';

  @override
  String get verificationScreenTitle => 'توثيق الحجز';

  @override
  String get verificationSubtitle => 'يرجى رفع المستندات المطلوبة لتأكيد حجزك.';

  @override
  String get verificationUnderReviewMessage =>
      'طلب التوثيق الخاص بك قيد المراجعة حاليًا.';

  @override
  String verificationRejectedMessage(String reason) {
    return 'تم رفض طلب التوثيق السابق الخاص بك.\nالسبب: \"$reason\"\n\nيرجى مراجعة السبب أعلاه، وتحديث مستنداتك إذا لزم الأمر، ثم إعادة إرسالها.';
  }

  @override
  String get idCardTitle => 'بطاقة الهوية';

  @override
  String get idCardSubtitle =>
      'ارفع صورة واحدة توضح بوضوح الوجهين الأمامي والخلفي لبطاقة هويتك.';

  @override
  String get personalPhotoTitle => 'صورة شخصية';

  @override
  String get personalPhotoSubtitle => 'ارفع صورة شخصية واضحة للتحقق من الهوية.';

  @override
  String get digitalSignatureTitle => 'التوقيع الرقمي';

  @override
  String get digitalSignatureSubtitle => 'وقّع باستخدام إصبعك أدناه.';

  @override
  String get uploadImageButton => 'رفع صورة';

  @override
  String get replaceImageButton => 'استبدال';

  @override
  String get removeImageButton => 'إزالة';

  @override
  String get clearSignatureButton => 'مسح';

  @override
  String get undoSignatureButton => 'تراجع';

  @override
  String get takePhotoOption => 'التقاط صورة';

  @override
  String get chooseFromGalleryOption => 'اختيار من المعرض';

  @override
  String get cameraPermissionDeniedTitle => 'الوصول إلى الكاميرا مطلوب';

  @override
  String get cameraPermissionDeniedMessage =>
      'يحتاج تطبيق Grande Beach إلى الوصول إلى الكاميرا لالتقاط هذه الصورة. يرجى السماح بذلك من إعدادات جهازك.';

  @override
  String get openSettingsButton => 'فتح الإعدادات';

  @override
  String get submitVerificationButton => 'إرسال للمراجعة';

  @override
  String get verificationIncompleteMessage =>
      'يرجى رفع بطاقة الهوية والصورة الشخصية والتوقيع للمتابعة.';

  @override
  String get verificationSubmittedTitle => 'تم إرسال التوثيق';

  @override
  String get verificationSubmittedMessage =>
      'شكرًا لك! تم إرسال مستنداتك بنجاح. يقوم فريقنا بمراجعتها وسنؤكد حجزك فور الموافقة عليها.';

  @override
  String get verificationErrorTitle => 'فشل الإرسال';

  @override
  String get errorSubmittingVerification =>
      'تعذر إرسال توثيقك. يرجى المحاولة مرة أخرى.';

  @override
  String get noBookingsYet => 'لا توجد حجوزات بعد';

  @override
  String get noBookingsYetSubtitle => 'لم تقم بأي حجز حتى الآن.';

  @override
  String get exploreChalets => 'استكشف الشاليهات';

  @override
  String get errorLoadingBookings => 'حدث خطأ أثناء تحميل حجوزاتك.';

  @override
  String get bookingTicketTitle => 'تذكرة الحجز';

  @override
  String get bookingNumberLabel => 'رقم الحجز';

  @override
  String get bookingDetailsTitle => 'تفاصيل الحجز';

  @override
  String get bookingInformationTitle => 'معلومات الحجز';

  @override
  String get customerInformationTitle => 'معلومات العميل';

  @override
  String get customerNameLabel => 'الاسم الكامل';

  @override
  String get customerEmailLabel => 'البريد الإلكتروني';

  @override
  String get customerPhoneLabel => 'رقم الهاتف';

  @override
  String get checkoutSummaryTitle => 'ملخص الفاتورة';

  @override
  String get nightsLabel => 'الليالي';

  @override
  String get guestCountLabel => 'عدد الضيوف';

  @override
  String get baseAmountLabel => 'المبلغ الاساسي (في الليلة)';

  @override
  String get taxAmountLabel => 'الضريبة';

  @override
  String get addOnAmountLabel => 'الإضافات';

  @override
  String get discountAmountLabel => 'الخصم';

  @override
  String get totalAmountLabel => 'الإجمالي';

  @override
  String get cancelReservation => 'إلغاء الحجز';

  @override
  String get close => 'إغلاق';

  @override
  String get bookingNotFoundTitle => 'الحجز غير موجود';

  @override
  String get bookingNotFoundSubtitle => 'تعذر العثور على هذا الحجز.';

  @override
  String get errorLoadingBookingDetails =>
      'تعذر تحميل هذا الحجز. يرجى المحاولة مرة أخرى.';

  @override
  String get cancelReservationSheetTitle => 'إلغاء الحجز';

  @override
  String get cancelReservationReasonLabel => 'سبب الإلغاء';

  @override
  String get cancelReservationReasonHint =>
      'أخبرنا لماذا تريد إلغاء هذا الحجز...';

  @override
  String get cancelReasonRequired => 'يرجى إدخال سبب الإلغاء.';

  @override
  String get confirmCancellation => 'تأكيد الإلغاء';

  @override
  String get bookingPendingCancellationMessage =>
      'طلب إلغاء الحجز الخاص بك قيد المراجعة.';

  @override
  String get errorCancelBooking =>
      'تعذر إلغاء هذا الحجز. يرجى المحاولة مرة أخرى.';

  @override
  String get cancellationReasonTitle => 'سبب الإلغاء';

  @override
  String get writeReviewButton => 'اكتب تقييمًا';

  @override
  String get submitReviewTitle => 'قيّم إقامتك';

  @override
  String get submitReviewSubtitle => 'شارك تجربتك لمساعدة الضيوف الآخرين.';

  @override
  String get reviewCommentLabel => 'تقييمك';

  @override
  String get reviewCommentHint => 'أخبرنا عن إقامتك...';

  @override
  String get submitReviewButton => 'إرسال التقييم';

  @override
  String get ratingRequiredError => 'يرجى اختيار تقييم.';

  @override
  String get reviewCommentRequiredError => 'يرجى كتابة تعليق.';

  @override
  String get reviewSubmittedMessage => 'شكرًا لك! تم إرسال تقييمك.';

  @override
  String get errorSubmittingReview =>
      'تعذر إرسال تقييمك. يرجى المحاولة مرة أخرى.';

  @override
  String get wishlistEmptyTitle => 'قائمة رغباتك فارغة';

  @override
  String get wishlistEmptySubtitle =>
      'اضغط على أيقونة القلب في أي شاليه لحفظه هنا.';

  @override
  String get reservationTitle => 'احجز';

  @override
  String get errorLoadingAvailability =>
      'تعذّر تحميل التوفر لهذا الشهر. يرجى المحاولة مرة أخرى.';

  @override
  String get selectedRangeUnavailable =>
      'هذه التواريخ غير متاحة. يرجى اختيار فترة متاحة.';

  @override
  String get reservationStep1Title => 'اختر التواريخ';

  @override
  String get reservationStep2Title => 'اختر الإضافات';

  @override
  String get reservationStep3Title => 'معاينة السعر';

  @override
  String guestCountMaxError(String max) {
    return 'الحد الأقصى المسموح به للضيوف هو $max.';
  }

  @override
  String addOnPerNightBadge(String price) {
    return '$price/الليلة';
  }

  @override
  String addOnFlatPriceBadge(String price) {
    return '$price';
  }

  @override
  String get weekendPricingNote =>
      'قد تختلف أسعار ليالي نهاية الأسبوع عن أيام الأسبوع.';

  @override
  String get addOnsListSubtitle =>
      'أضف لمسة مميزة على إقامتك مع هذه الإضافات الاختيارية.';

  @override
  String get noAddOnsTitle => 'لا توجد إضافات متاحة';

  @override
  String get noAddOnsSubtitle => 'لا توجد إضافات اختيارية متاحة لهذا الشاليه.';

  @override
  String get errorLoadingAddOns =>
      'تعذر تحميل الإضافات. يرجى المحاولة مرة أخرى.';

  @override
  String get errorLoadingPricePreview =>
      'تعذر تحميل معاينة السعر. يرجى المحاولة مرة أخرى.';

  @override
  String get priceBreakdownTitle => 'تفاصيل السعر';

  @override
  String get backToHomeButton => 'العودة إلى الرئيسية';

  @override
  String get nextButton => 'التالي';

  @override
  String get backButton => 'رجوع';

  @override
  String get bookingSuccessTitle => 'تم إرسال الحجز';

  @override
  String get bookingSuccessMessage =>
      'نحن ننظر في حجزك. سيتواصل معك فريق خدمة العملاء بمجرد تأكيد الحجز.';

  @override
  String get bookingErrorTitle => 'فشل الحجز';

  @override
  String get errorSubmittingBooking =>
      'تعذر إرسال حجزك. يرجى المحاولة مرة أخرى.';

  @override
  String get tryAgainButton => 'حاول مرة أخرى';

  @override
  String get whatsappSupportMessage =>
      'مرحبًا، أحتاج إلى مساعدة بخصوص GrandeBeach Khairan.';

  @override
  String whatsappChaletInquiryMessage(String chaletName) {
    return 'مرحبًا،\nأود الاستفسار عن سياسة الالغاء الخاصة  بهذا الشاليه .\n\nالشاليه:\n$chaletName\n\nشكرًا لكم.';
  }

  @override
  String whatsappChaletCancelationPolicyInquiryMessage(String chaletName) {
    return 'مرحبًا،\nأود الاستفسار عن تفاصيل هذا الشاليه .\n\nالشاليه:\n$chaletName\n\nشكرًا لكم.';
  }

  @override
  String get whatsappBookingSupportMessage =>
      'مرحبًا،\nأحتاج إلى مساعدة بخصوص حجزي في GrandeBeach Khairan.\n\nشكرًا لكم.';

  @override
  String whatsappBookingSupportMessageWithNumber(String bookingNumber) {
    return 'مرحبًا،\nأحتاج إلى مساعدة بخصوص حجزي في GrandeBeach Khairan.\n\nرقم الحجز:\n$bookingNumber\n\nشكرًا لكم.';
  }

  @override
  String get specialRequestLabel => 'طلب خاص (اختياري)';

  @override
  String get specialRequestHint =>
      'هل تريد إخبارنا بأي شيء؟ (مثال: تسجيل وصول مبكر)';

  @override
  String get cancellationPolicyTitle => 'سياسة الإلغاء';

  @override
  String get cancellationPolicyContactMessage =>
      'إذا كنت تريد الاستفسار عن سياسة الإلغاء لهذا الشاليه، يرجى التواصل معنا عبر واتساب.';

  @override
  String get contactUsOnWhatsapp => 'تواصل معنا عبر واتساب';
}
