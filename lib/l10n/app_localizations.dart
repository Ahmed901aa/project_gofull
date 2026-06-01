import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
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
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

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

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'GO FULL'**
  String get appName;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get login;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number and password to sign in.'**
  String get loginSubtitle;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get phoneHint;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get passwordHint;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter password'**
  String get confirmPasswordHint;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get loginButton;

  /// No description provided for @termsText.
  ///
  /// In en, this message translates to:
  /// **'By continuing, you agree to the Terms of Service and Privacy Policy'**
  String get termsText;

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create New Account'**
  String get createAccountTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get nameHint;

  /// No description provided for @accountType.
  ///
  /// In en, this message translates to:
  /// **'Account Type'**
  String get accountType;

  /// No description provided for @roleDriver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get roleDriver;

  /// No description provided for @roleProvider.
  ///
  /// In en, this message translates to:
  /// **'Service Provider'**
  String get roleProvider;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerButton;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @welcomePrefix.
  ///
  /// In en, this message translates to:
  /// **'Hello,'**
  String get welcomePrefix;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Wishing you a safe journey'**
  String get welcomeSubtitle;

  /// No description provided for @fuelSupply.
  ///
  /// In en, this message translates to:
  /// **'Fuel Delivery'**
  String get fuelSupply;

  /// No description provided for @fuelSupplyDesc.
  ///
  /// In en, this message translates to:
  /// **'Delivered to your location'**
  String get fuelSupplyDesc;

  /// No description provided for @towTruckService.
  ///
  /// In en, this message translates to:
  /// **'Tow Truck'**
  String get towTruckService;

  /// No description provided for @towTruckServiceDesc.
  ///
  /// In en, this message translates to:
  /// **'Fast tow & rescue'**
  String get towTruckServiceDesc;

  /// No description provided for @currentOrder.
  ///
  /// In en, this message translates to:
  /// **'Current Order'**
  String get currentOrder;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @offersForYou.
  ///
  /// In en, this message translates to:
  /// **'Special Offers'**
  String get offersForYou;

  /// No description provided for @subscriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'All emergency services in one subscription'**
  String get subscriptionTitle;

  /// No description provided for @subscriptionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Free vouchers + exclusive discounts'**
  String get subscriptionSubtitle;

  /// No description provided for @departurePoint.
  ///
  /// In en, this message translates to:
  /// **'Pickup Point'**
  String get departurePoint;

  /// No description provided for @arrivalPoint.
  ///
  /// In en, this message translates to:
  /// **'Drop-off Point'**
  String get arrivalPoint;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get currentLocation;

  /// No description provided for @yourCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Your Current Location'**
  String get yourCurrentLocation;

  /// No description provided for @selectLocationOnMap.
  ///
  /// In en, this message translates to:
  /// **'Select location on map'**
  String get selectLocationOnMap;

  /// No description provided for @searchLocation.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchLocation;

  /// No description provided for @confirmLocation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get confirmLocation;

  /// No description provided for @deliveryDestination.
  ///
  /// In en, this message translates to:
  /// **'Delivery Destination'**
  String get deliveryDestination;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @recentLocations.
  ///
  /// In en, this message translates to:
  /// **'Recent Locations'**
  String get recentLocations;

  /// No description provided for @useCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use your current location'**
  String get useCurrentLocation;

  /// No description provided for @chooseOnMap.
  ///
  /// In en, this message translates to:
  /// **'Choose on map'**
  String get chooseOnMap;

  /// No description provided for @selectFuelType.
  ///
  /// In en, this message translates to:
  /// **'Select Fuel Type'**
  String get selectFuelType;

  /// No description provided for @gasoline91.
  ///
  /// In en, this message translates to:
  /// **'Gasoline 91'**
  String get gasoline91;

  /// No description provided for @gasoline95.
  ///
  /// In en, this message translates to:
  /// **'Gasoline 95'**
  String get gasoline95;

  /// No description provided for @diesel.
  ///
  /// In en, this message translates to:
  /// **'Diesel'**
  String get diesel;

  /// No description provided for @fuelQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get fuelQuantity;

  /// No description provided for @liters20.
  ///
  /// In en, this message translates to:
  /// **'20 Liters'**
  String get liters20;

  /// No description provided for @liters40.
  ///
  /// In en, this message translates to:
  /// **'40 Liters'**
  String get liters40;

  /// No description provided for @liters60.
  ///
  /// In en, this message translates to:
  /// **'60 Liters'**
  String get liters60;

  /// No description provided for @fullTank.
  ///
  /// In en, this message translates to:
  /// **'Full Tank'**
  String get fullTank;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get myOrders;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get myAccount;

  /// No description provided for @useCode.
  ///
  /// In en, this message translates to:
  /// **'Use code: '**
  String get useCode;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @subscribeNow.
  ///
  /// In en, this message translates to:
  /// **'Subscribe Now'**
  String get subscribeNow;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @searchingForOrder.
  ///
  /// In en, this message translates to:
  /// **'Looking for tow requests...'**
  String get searchingForOrder;

  /// No description provided for @searchingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Finding the nearest available orders for you.'**
  String get searchingSubtitle;

  /// No description provided for @incomingOrders.
  ///
  /// In en, this message translates to:
  /// **'Incoming Orders'**
  String get incomingOrders;

  /// No description provided for @orderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetails;

  /// No description provided for @acceptOrder.
  ///
  /// In en, this message translates to:
  /// **'Accept Order'**
  String get acceptOrder;

  /// No description provided for @rejectOrder.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get rejectOrder;

  /// No description provided for @towService.
  ///
  /// In en, this message translates to:
  /// **'Tow Service'**
  String get towService;

  /// No description provided for @fuelService.
  ///
  /// In en, this message translates to:
  /// **'Fuel Service'**
  String get fuelService;

  /// No description provided for @distanceAway.
  ///
  /// In en, this message translates to:
  /// **'away'**
  String get distanceAway;

  /// No description provided for @km.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get km;

  /// No description provided for @driverProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get driverProfile;

  /// No description provided for @supportTeam.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportTeam;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @recentOrders.
  ///
  /// In en, this message translates to:
  /// **'Recent Orders'**
  String get recentOrders;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @towDriver.
  ///
  /// In en, this message translates to:
  /// **'Tow Driver'**
  String get towDriver;

  /// No description provided for @customerInfo.
  ///
  /// In en, this message translates to:
  /// **'Customer Info'**
  String get customerInfo;

  /// No description provided for @carPhotos.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Photos'**
  String get carPhotos;

  /// No description provided for @tripRoute.
  ///
  /// In en, this message translates to:
  /// **'Trip Route'**
  String get tripRoute;

  /// No description provided for @customerNotes.
  ///
  /// In en, this message translates to:
  /// **'Customer Notes'**
  String get customerNotes;

  /// No description provided for @paymentSummaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Summary'**
  String get paymentSummaryLabel;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalAmount;

  /// No description provided for @cashPayment.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cashPayment;

  /// No description provided for @confirmAcceptTitle.
  ///
  /// In en, this message translates to:
  /// **'Accept This Order?'**
  String get confirmAcceptTitle;

  /// No description provided for @confirmAcceptMessage.
  ///
  /// In en, this message translates to:
  /// **'The customer will be notified immediately once you accept.'**
  String get confirmAcceptMessage;

  /// No description provided for @confirmAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get confirmAccept;

  /// No description provided for @startMovingToCustomer.
  ///
  /// In en, this message translates to:
  /// **'Head to Customer'**
  String get startMovingToCustomer;

  /// No description provided for @driverDetails.
  ///
  /// In en, this message translates to:
  /// **'Driver Details'**
  String get driverDetails;

  /// No description provided for @navigateToCustomer.
  ///
  /// In en, this message translates to:
  /// **'Navigate to Customer'**
  String get navigateToCustomer;

  /// No description provided for @navigateToDestination.
  ///
  /// In en, this message translates to:
  /// **'Navigate to Destination'**
  String get navigateToDestination;

  /// No description provided for @openInGoogleMaps.
  ///
  /// In en, this message translates to:
  /// **'Open in Google Maps'**
  String get openInGoogleMaps;

  /// No description provided for @arrivedStartDoc.
  ///
  /// In en, this message translates to:
  /// **'Arrived — Start Documentation'**
  String get arrivedStartDoc;

  /// No description provided for @deliveryDestinationLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery Destination'**
  String get deliveryDestinationLabel;

  /// No description provided for @documentation.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get documentation;

  /// No description provided for @mandatoryDoc.
  ///
  /// In en, this message translates to:
  /// **'Required Documentation'**
  String get mandatoryDoc;

  /// No description provided for @mandatoryDocDesc.
  ///
  /// In en, this message translates to:
  /// **'Take 4 clear photos from all sides of the vehicle before starting the tow. This protects both you and the customer.'**
  String get mandatoryDocDesc;

  /// No description provided for @frontSide.
  ///
  /// In en, this message translates to:
  /// **'Front'**
  String get frontSide;

  /// No description provided for @capturePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a clear photo'**
  String get capturePhoto;

  /// No description provided for @capture.
  ///
  /// In en, this message translates to:
  /// **'Capture'**
  String get capture;

  /// No description provided for @retake.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retake;

  /// No description provided for @startToDestination.
  ///
  /// In en, this message translates to:
  /// **'Head to Destination'**
  String get startToDestination;

  /// No description provided for @captureAllPhotos.
  ///
  /// In en, this message translates to:
  /// **'Please capture all photos to continue'**
  String get captureAllPhotos;

  /// No description provided for @collectPayment.
  ///
  /// In en, this message translates to:
  /// **'Collect Payment'**
  String get collectPayment;

  /// No description provided for @collectionInstructions.
  ///
  /// In en, this message translates to:
  /// **'Collection Instructions'**
  String get collectionInstructions;

  /// No description provided for @confirmFullAmount.
  ///
  /// In en, this message translates to:
  /// **'Make sure you\'ve received the full amount before confirming.'**
  String get confirmFullAmount;

  /// No description provided for @cashOnly.
  ///
  /// In en, this message translates to:
  /// **'Cash payment only'**
  String get cashOnly;

  /// No description provided for @requiredAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount to Collect'**
  String get requiredAmount;

  /// No description provided for @confirmReceived.
  ///
  /// In en, this message translates to:
  /// **'Confirm Payment Received'**
  String get confirmReceived;

  /// No description provided for @taskComplete.
  ///
  /// In en, this message translates to:
  /// **'Task Complete'**
  String get taskComplete;

  /// No description provided for @orderCompletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Order completed successfully!'**
  String get orderCompletedSuccess;

  /// No description provided for @earningsRecorded.
  ///
  /// In en, this message translates to:
  /// **'Payment recorded and added to your balance.'**
  String get earningsRecorded;

  /// No description provided for @addedEarnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings Added'**
  String get addedEarnings;

  /// No description provided for @rateCustomer.
  ///
  /// In en, this message translates to:
  /// **'Rate Customer'**
  String get rateCustomer;

  /// No description provided for @rateTrip.
  ///
  /// In en, this message translates to:
  /// **'Rate Trip'**
  String get rateTrip;

  /// No description provided for @howWasCustomer.
  ///
  /// In en, this message translates to:
  /// **'How was the customer?'**
  String get howWasCustomer;

  /// No description provided for @ratingHelps.
  ///
  /// In en, this message translates to:
  /// **'Your rating helps us ensure a safe, comfortable experience for everyone.'**
  String get ratingHelps;

  /// No description provided for @additionalNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes for management'**
  String get additionalNotes;

  /// No description provided for @additionalNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Any details you\'d like to report'**
  String get additionalNotesHint;

  /// No description provided for @submitRating.
  ///
  /// In en, this message translates to:
  /// **'Submit Rating'**
  String get submitRating;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @joinDate.
  ///
  /// In en, this message translates to:
  /// **'Joined'**
  String get joinDate;

  /// No description provided for @since.
  ///
  /// In en, this message translates to:
  /// **'Since'**
  String get since;

  /// No description provided for @salary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get salary;

  /// No description provided for @fixedSalary.
  ///
  /// In en, this message translates to:
  /// **'Fixed salary:'**
  String get fixedSalary;

  /// No description provided for @vehicle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicle;

  /// No description provided for @vehicleType.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get vehicleType;

  /// No description provided for @plateNumber.
  ///
  /// In en, this message translates to:
  /// **'Plate Number'**
  String get plateNumber;

  /// No description provided for @documents.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documents;

  /// No description provided for @nationalId.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nationalId;

  /// No description provided for @drivingLicense.
  ///
  /// In en, this message translates to:
  /// **'Driving License'**
  String get drivingLicense;

  /// No description provided for @underReview.
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get underReview;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get accepted;

  /// No description provided for @required_.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required_;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @uploadFile.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get uploadFile;

  /// No description provided for @hydraulicWinch.
  ///
  /// In en, this message translates to:
  /// **'Hydraulic Tow Truck'**
  String get hydraulicWinch;

  /// No description provided for @workHours.
  ///
  /// In en, this message translates to:
  /// **'Work Hours'**
  String get workHours;

  /// No description provided for @totalTrips.
  ///
  /// In en, this message translates to:
  /// **'Total Trips'**
  String get totalTrips;

  /// No description provided for @averageRating.
  ///
  /// In en, this message translates to:
  /// **'Avg. Rating'**
  String get averageRating;

  /// No description provided for @distanceCovered.
  ///
  /// In en, this message translates to:
  /// **'Distance Covered'**
  String get distanceCovered;

  /// No description provided for @fromYesterday.
  ///
  /// In en, this message translates to:
  /// **'from yesterday'**
  String get fromYesterday;

  /// No description provided for @taskProductivity.
  ///
  /// In en, this message translates to:
  /// **'Productivity'**
  String get taskProductivity;

  /// No description provided for @responseRate.
  ///
  /// In en, this message translates to:
  /// **'Response Rate'**
  String get responseRate;

  /// No description provided for @highestAcceptRate.
  ///
  /// In en, this message translates to:
  /// **'Top Acceptance Rate'**
  String get highestAcceptRate;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @sixMonths.
  ///
  /// In en, this message translates to:
  /// **'6 Months'**
  String get sixMonths;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @driverRecentOrders.
  ///
  /// In en, this message translates to:
  /// **'Recent Orders'**
  String get driverRecentOrders;

  /// No description provided for @driverTripDetails.
  ///
  /// In en, this message translates to:
  /// **'Trip Details'**
  String get driverTripDetails;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @carLocation.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Location'**
  String get carLocation;

  /// No description provided for @fuelDetails.
  ///
  /// In en, this message translates to:
  /// **'Fuel Details'**
  String get fuelDetails;

  /// No description provided for @orderedQuantity.
  ///
  /// In en, this message translates to:
  /// **'Ordered Quantity'**
  String get orderedQuantity;

  /// No description provided for @fuelType.
  ///
  /// In en, this message translates to:
  /// **'Fuel Type'**
  String get fuelType;

  /// No description provided for @pricePerLiter.
  ///
  /// In en, this message translates to:
  /// **'Price per Liter'**
  String get pricePerLiter;

  /// No description provided for @carDetails.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details'**
  String get carDetails;

  /// No description provided for @carType.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get carType;

  /// No description provided for @photoLog.
  ///
  /// In en, this message translates to:
  /// **'Photo Log'**
  String get photoLog;

  /// No description provided for @pickupPhotos.
  ///
  /// In en, this message translates to:
  /// **'Pickup Photos'**
  String get pickupPhotos;

  /// No description provided for @deliveryPhotos.
  ///
  /// In en, this message translates to:
  /// **'Delivery Photos'**
  String get deliveryPhotos;

  /// No description provided for @rateTripButton.
  ///
  /// In en, this message translates to:
  /// **'Rate Trip'**
  String get rateTripButton;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @technicalSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get technicalSupport;

  /// No description provided for @directCall.
  ///
  /// In en, this message translates to:
  /// **'Call Us'**
  String get directCall;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone:'**
  String get phoneNumber;

  /// No description provided for @directChat.
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get directChat;

  /// No description provided for @directChatDesc.
  ///
  /// In en, this message translates to:
  /// **'Start a live chat with our support team.'**
  String get directChatDesc;

  /// No description provided for @startChat.
  ///
  /// In en, this message translates to:
  /// **'Start Chat'**
  String get startChat;

  /// No description provided for @inquiryDesc.
  ///
  /// In en, this message translates to:
  /// **'You can also describe your inquiry below, and we\'ll get back to you shortly.'**
  String get inquiryDesc;

  /// No description provided for @addNotes.
  ///
  /// In en, this message translates to:
  /// **'Your message'**
  String get addNotes;

  /// No description provided for @addNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Write any details you\'d like to share...'**
  String get addNotesHint;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @fuelServiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Fuel Service'**
  String get fuelServiceLabel;

  /// No description provided for @collectServiceAmount.
  ///
  /// In en, this message translates to:
  /// **'Collect Payment'**
  String get collectServiceAmount;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a location...'**
  String get searchHint;

  /// No description provided for @confirmLocationBtn.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get confirmLocationBtn;

  /// No description provided for @pageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page Not Found'**
  String get pageNotFound;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @serviceFee.
  ///
  /// In en, this message translates to:
  /// **'Service Fee'**
  String get serviceFee;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @fuelDelivery.
  ///
  /// In en, this message translates to:
  /// **'Fuel Delivery'**
  String get fuelDelivery;

  /// No description provided for @towingService.
  ///
  /// In en, this message translates to:
  /// **'Towing Service'**
  String get towingService;

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocation;

  /// No description provided for @fuelDetailsLabel.
  ///
  /// In en, this message translates to:
  /// **'Fuel Details'**
  String get fuelDetailsLabel;

  /// No description provided for @additionalNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes'**
  String get additionalNotesLabel;

  /// No description provided for @additionalNotesHintField.
  ///
  /// In en, this message translates to:
  /// **'Notes about the vehicle condition'**
  String get additionalNotesHintField;

  /// No description provided for @paymentSummary.
  ///
  /// In en, this message translates to:
  /// **'Payment Summary'**
  String get paymentSummary;

  /// No description provided for @priceAfterFill.
  ///
  /// In en, this message translates to:
  /// **'Price will be determined after filling'**
  String get priceAfterFill;

  /// No description provided for @searchingForFuelProvider.
  ///
  /// In en, this message translates to:
  /// **'Finding the nearest fuel provider'**
  String get searchingForFuelProvider;

  /// No description provided for @searchingFuelSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Matching your order with the nearest equipped fuel vehicle.'**
  String get searchingFuelSubtitle;

  /// No description provided for @searchingForTowDriver.
  ///
  /// In en, this message translates to:
  /// **'Finding the nearest tow driver'**
  String get searchingForTowDriver;

  /// No description provided for @searchingTowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Matching your order with the nearest available tow truck.'**
  String get searchingTowSubtitle;

  /// No description provided for @fuelProviderFound.
  ///
  /// In en, this message translates to:
  /// **'Fuel Provider Found!'**
  String get fuelProviderFound;

  /// No description provided for @towTruckFound.
  ///
  /// In en, this message translates to:
  /// **'Tow Truck Found!'**
  String get towTruckFound;

  /// No description provided for @vehicleLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get vehicleLabel;

  /// No description provided for @fuelSupplyVehicle.
  ///
  /// In en, this message translates to:
  /// **'Fuel Supply Vehicle'**
  String get fuelSupplyVehicle;

  /// No description provided for @hydraulicTowTruck.
  ///
  /// In en, this message translates to:
  /// **'Hydraulic Tow Truck'**
  String get hydraulicTowTruck;

  /// No description provided for @fuelProviderOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'Fuel Provider On the Way'**
  String get fuelProviderOnTheWay;

  /// No description provided for @towDriverOnTheWay.
  ///
  /// In en, this message translates to:
  /// **'Tow Driver On the Way'**
  String get towDriverOnTheWay;

  /// No description provided for @providerMovingToYou.
  ///
  /// In en, this message translates to:
  /// **'The provider is heading to your location. Please wait in a safe area.'**
  String get providerMovingToYou;

  /// No description provided for @driverAcceptedOrder.
  ///
  /// In en, this message translates to:
  /// **'The driver accepted your order and is on the way.'**
  String get driverAcceptedOrder;

  /// No description provided for @orderCancelled.
  ///
  /// In en, this message translates to:
  /// **'Order Cancelled'**
  String get orderCancelled;

  /// No description provided for @orderCancelledByProvider.
  ///
  /// In en, this message translates to:
  /// **'Order cancelled by the provider. Finding another one for you.'**
  String get orderCancelledByProvider;

  /// No description provided for @orderCancelledByCustomer.
  ///
  /// In en, this message translates to:
  /// **'Order cancelled by the customer.'**
  String get orderCancelledByCustomer;

  /// No description provided for @orderCancelledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Order cancelled successfully.'**
  String get orderCancelledSuccess;

  /// No description provided for @cancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancelOrder;

  /// No description provided for @cancelOrderConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order?'**
  String get cancelOrderConfirmTitle;

  /// No description provided for @cancelOrderConfirmSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel?\nThe customer will be notified.'**
  String get cancelOrderConfirmSubtitle;

  /// No description provided for @cancelOrderConfirmBtn.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancelOrderConfirmBtn;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @providerEnRoute.
  ///
  /// In en, this message translates to:
  /// **'Provider on the way'**
  String get providerEnRoute;

  /// No description provided for @providerArrived.
  ///
  /// In en, this message translates to:
  /// **'Provider arrived'**
  String get providerArrived;

  /// No description provided for @serviceInProgress.
  ///
  /// In en, this message translates to:
  /// **'Service in progress'**
  String get serviceInProgress;

  /// No description provided for @serviceCompleted.
  ///
  /// In en, this message translates to:
  /// **'Service completed. Please rate your experience.'**
  String get serviceCompleted;

  /// No description provided for @rateService.
  ///
  /// In en, this message translates to:
  /// **'Rate Service'**
  String get rateService;

  /// No description provided for @thankYouRating.
  ///
  /// In en, this message translates to:
  /// **'Thanks for your rating!'**
  String get thankYouRating;

  /// No description provided for @ratingFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not submit rating. Please try again.'**
  String get ratingFailed;

  /// No description provided for @tapStarsToRate.
  ///
  /// In en, this message translates to:
  /// **'Tap to rate'**
  String get tapStarsToRate;

  /// No description provided for @writeCommentHint.
  ///
  /// In en, this message translates to:
  /// **'Write your comment (optional)'**
  String get writeCommentHint;

  /// No description provided for @submitRatingBtn.
  ///
  /// In en, this message translates to:
  /// **'Submit Rating'**
  String get submitRatingBtn;

  /// No description provided for @ratingBad.
  ///
  /// In en, this message translates to:
  /// **'Bad'**
  String get ratingBad;

  /// No description provided for @ratingAcceptable.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get ratingAcceptable;

  /// No description provided for @ratingGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get ratingGood;

  /// No description provided for @ratingVeryGood.
  ///
  /// In en, this message translates to:
  /// **'Very Good'**
  String get ratingVeryGood;

  /// No description provided for @ratingExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get ratingExcellent;

  /// No description provided for @routeSection.
  ///
  /// In en, this message translates to:
  /// **'Trip Route'**
  String get routeSection;

  /// No description provided for @carDetailsSection.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details'**
  String get carDetailsSection;

  /// No description provided for @carTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Vehicle type'**
  String get carTypeHint;

  /// No description provided for @plateNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Plate number'**
  String get plateNumberHint;

  /// No description provided for @towingDestination.
  ///
  /// In en, this message translates to:
  /// **'Towing Destination'**
  String get towingDestination;

  /// No description provided for @resumeOrder.
  ///
  /// In en, this message translates to:
  /// **'Resume Order'**
  String get resumeOrder;

  /// No description provided for @pendingAcceptance.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingAcceptance;

  /// No description provided for @orderAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get orderAccepted;

  /// No description provided for @enRoute.
  ///
  /// In en, this message translates to:
  /// **'On the Way'**
  String get enRoute;

  /// No description provided for @arrived.
  ///
  /// In en, this message translates to:
  /// **'Arrived'**
  String get arrived;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @activeOrderWarning.
  ///
  /// In en, this message translates to:
  /// **'You already have an active order. Complete or cancel it before placing a new one.'**
  String get activeOrderWarning;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Connection failed. Check your internet and try again.'**
  String get networkError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get serverError;

  /// No description provided for @sessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please log in again.'**
  String get sessionExpired;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission for this action.'**
  String get permissionDenied;

  /// No description provided for @numberCopied.
  ///
  /// In en, this message translates to:
  /// **'Number copied'**
  String get numberCopied;

  /// No description provided for @photoSavedToGallery.
  ///
  /// In en, this message translates to:
  /// **'Photo saved to gallery'**
  String get photoSavedToGallery;

  /// No description provided for @changesSaved.
  ///
  /// In en, this message translates to:
  /// **'Changes saved'**
  String get changesSaved;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account?'**
  String get deleteAccount;

  /// No description provided for @deleteAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove all your data and order history. This cannot be undone.'**
  String get deleteAccountSubtitle;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get confirmDelete;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Out?'**
  String get logoutTitle;

  /// No description provided for @logoutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out? You can come back anytime.'**
  String get logoutSubtitle;

  /// No description provided for @logoutBtn.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logoutBtn;

  /// No description provided for @stayBtn.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get stayBtn;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get terms;

  /// No description provided for @discountCodes.
  ///
  /// In en, this message translates to:
  /// **'Discount Codes'**
  String get discountCodes;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @photoCapture.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Photo'**
  String get photoCapture;

  /// No description provided for @photoSaved.
  ///
  /// In en, this message translates to:
  /// **'Photo saved'**
  String get photoSaved;

  /// No description provided for @supportAvailable.
  ///
  /// In en, this message translates to:
  /// **'Our support team is here to help'**
  String get supportAvailable;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone:'**
  String get mobileNumber;

  /// No description provided for @carPlate.
  ///
  /// In en, this message translates to:
  /// **'Plate Number'**
  String get carPlate;

  /// No description provided for @vehicleInfo.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicleInfo;

  /// No description provided for @fuelOrder.
  ///
  /// In en, this message translates to:
  /// **'Fuel Order'**
  String get fuelOrder;

  /// No description provided for @towOrder.
  ///
  /// In en, this message translates to:
  /// **'Tow Order'**
  String get towOrder;

  /// No description provided for @searchResults.
  ///
  /// In en, this message translates to:
  /// **'Search results...'**
  String get searchResults;

  /// No description provided for @fuelDiscount.
  ///
  /// In en, this message translates to:
  /// **'20% off your first fuel order'**
  String get fuelDiscount;

  /// No description provided for @towDiscount.
  ///
  /// In en, this message translates to:
  /// **'20% off your first tow order'**
  String get towDiscount;

  /// No description provided for @tripCompleted.
  ///
  /// In en, this message translates to:
  /// **'Trip Complete'**
  String get tripCompleted;

  /// No description provided for @tripCompletedMsg.
  ///
  /// In en, this message translates to:
  /// **'Thank you for using GO FULL!'**
  String get tripCompletedMsg;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @serviceArrived.
  ///
  /// In en, this message translates to:
  /// **'Provider Arrived'**
  String get serviceArrived;

  /// No description provided for @arrivedMsg.
  ///
  /// In en, this message translates to:
  /// **'The provider has arrived at your location.'**
  String get arrivedMsg;

  /// No description provided for @noOrdersYet.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get noOrdersYet;

  /// No description provided for @noOrdersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your orders will appear here once you place one.'**
  String get noOrdersSubtitle;

  /// No description provided for @pendingStatus.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingStatus;

  /// No description provided for @acceptedStatus.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get acceptedStatus;

  /// No description provided for @enRouteStatus.
  ///
  /// In en, this message translates to:
  /// **'On the Way'**
  String get enRouteStatus;

  /// No description provided for @arrivedStatus.
  ///
  /// In en, this message translates to:
  /// **'Arrived'**
  String get arrivedStatus;

  /// No description provided for @inProgressStatus.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgressStatus;

  /// No description provided for @completedStatus.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedStatus;

  /// No description provided for @cancelledStatus.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelledStatus;

  /// No description provided for @liters.
  ///
  /// In en, this message translates to:
  /// **'Liters'**
  String get liters;

  /// No description provided for @gasoline.
  ///
  /// In en, this message translates to:
  /// **'Gasoline'**
  String get gasoline;

  /// No description provided for @perLiter.
  ///
  /// In en, this message translates to:
  /// **'per liter'**
  String get perLiter;

  /// No description provided for @fullTankLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Tank'**
  String get fullTankLabel;

  /// No description provided for @safetyNotice.
  ///
  /// In en, this message translates to:
  /// **'Your safety matters. Please wait in a safe, visible location.'**
  String get safetyNotice;

  /// No description provided for @cancelOrderCustomer.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancelOrderCustomer;

  /// No description provided for @cancelOrderCustomerConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this order?'**
  String get cancelOrderCustomerConfirm;

  /// No description provided for @yesCancel.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get yesCancel;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @aboutGoFull.
  ///
  /// In en, this message translates to:
  /// **'About GO FULL'**
  String get aboutGoFull;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learnMore;

  /// No description provided for @orderNow.
  ///
  /// In en, this message translates to:
  /// **'Order Now'**
  String get orderNow;

  /// No description provided for @useCodeBtn.
  ///
  /// In en, this message translates to:
  /// **'Use Code'**
  String get useCodeBtn;

  /// No description provided for @bannerAllServicesIn.
  ///
  /// In en, this message translates to:
  /// **'Fuel & towing covered in\n'**
  String get bannerAllServicesIn;

  /// No description provided for @bannerOneSubscription.
  ///
  /// In en, this message translates to:
  /// **'one plan'**
  String get bannerOneSubscription;

  /// No description provided for @bannerFreeVouchers.
  ///
  /// In en, this message translates to:
  /// **'Free vouchers + VIP discounts'**
  String get bannerFreeVouchers;

  /// No description provided for @bannerExclusiveOffer.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get bannerExclusiveOffer;

  /// No description provided for @bannerTowRoundClock.
  ///
  /// In en, this message translates to:
  /// **'Roadside rescue\n'**
  String get bannerTowRoundClock;

  /// No description provided for @bannerTwentyFourHours.
  ///
  /// In en, this message translates to:
  /// **'24/7'**
  String get bannerTwentyFourHours;

  /// No description provided for @bannerFastResponse.
  ///
  /// In en, this message translates to:
  /// **'Fastest response guaranteed'**
  String get bannerFastResponse;

  /// No description provided for @bannerAvailableNow.
  ///
  /// In en, this message translates to:
  /// **'Always On'**
  String get bannerAvailableNow;

  /// No description provided for @bannerGetDiscount.
  ///
  /// In en, this message translates to:
  /// **'Save '**
  String get bannerGetDiscount;

  /// No description provided for @bannerTwentyPercent.
  ///
  /// In en, this message translates to:
  /// **'20% today'**
  String get bannerTwentyPercent;

  /// No description provided for @bannerUseCodeGO20.
  ///
  /// In en, this message translates to:
  /// **'Code: GO20'**
  String get bannerUseCodeGO20;

  /// No description provided for @bannerLimitedTime.
  ///
  /// In en, this message translates to:
  /// **'Ends Soon'**
  String get bannerLimitedTime;

  /// No description provided for @searchFuelDelivery.
  ///
  /// In en, this message translates to:
  /// **'Fuel Delivery'**
  String get searchFuelDelivery;

  /// No description provided for @searchFuelDeliveryDesc.
  ///
  /// In en, this message translates to:
  /// **'Fuel delivery to your location'**
  String get searchFuelDeliveryDesc;

  /// No description provided for @searchTowing.
  ///
  /// In en, this message translates to:
  /// **'Towing'**
  String get searchTowing;

  /// No description provided for @searchTowingDesc.
  ///
  /// In en, this message translates to:
  /// **'Vehicle towing service'**
  String get searchTowingDesc;

  /// No description provided for @searchMyOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get searchMyOrders;

  /// No description provided for @searchMyOrdersDesc.
  ///
  /// In en, this message translates to:
  /// **'View current and past orders'**
  String get searchMyOrdersDesc;

  /// No description provided for @searchDiscountCodes.
  ///
  /// In en, this message translates to:
  /// **'Discount Codes'**
  String get searchDiscountCodes;

  /// No description provided for @searchDiscountCodesDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter and view discount codes'**
  String get searchDiscountCodesDesc;

  /// No description provided for @searchFAQ.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get searchFAQ;

  /// No description provided for @searchFAQDesc.
  ///
  /// In en, this message translates to:
  /// **'Answers to common questions'**
  String get searchFAQDesc;

  /// No description provided for @searchEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get searchEditProfile;

  /// No description provided for @searchEditProfileDesc.
  ///
  /// In en, this message translates to:
  /// **'Edit name and phone number'**
  String get searchEditProfileDesc;

  /// No description provided for @searchTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get searchTerms;

  /// No description provided for @searchTermsDesc.
  ///
  /// In en, this message translates to:
  /// **'App terms of use'**
  String get searchTermsDesc;

  /// No description provided for @searchSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get searchSupport;

  /// No description provided for @searchSupportDesc.
  ///
  /// In en, this message translates to:
  /// **'Contact us for help'**
  String get searchSupportDesc;

  /// No description provided for @servicesCategory.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesCategory;

  /// No description provided for @appCategory.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get appCategory;

  /// No description provided for @accountCategory.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountCategory;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @towingScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Tow Truck'**
  String get towingScreenTitle;

  /// No description provided for @fuelScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Fuel Delivery'**
  String get fuelScreenTitle;

  /// No description provided for @locationSection.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationSection;

  /// No description provided for @tripRouteSection.
  ///
  /// In en, this message translates to:
  /// **'Trip Route'**
  String get tripRouteSection;

  /// No description provided for @carDetailsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details'**
  String get carDetailsSectionTitle;

  /// No description provided for @additionalNotesSection.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes'**
  String get additionalNotesSection;

  /// No description provided for @paymentSummarySection.
  ///
  /// In en, this message translates to:
  /// **'Payment Summary'**
  String get paymentSummarySection;

  /// No description provided for @towingDestinationPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Towing destination'**
  String get towingDestinationPlaceholder;

  /// No description provided for @pleaseSelectLocation.
  ///
  /// In en, this message translates to:
  /// **'Please select your location'**
  String get pleaseSelectLocation;

  /// No description provided for @pleaseSelectDestination.
  ///
  /// In en, this message translates to:
  /// **'Please select a destination'**
  String get pleaseSelectDestination;

  /// No description provided for @pleaseEnterCarType.
  ///
  /// In en, this message translates to:
  /// **'Please enter the vehicle type'**
  String get pleaseEnterCarType;

  /// No description provided for @pleaseEnterPlateNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter the plate number'**
  String get pleaseEnterPlateNumber;

  /// No description provided for @pleaseSelectFuelType.
  ///
  /// In en, this message translates to:
  /// **'Please select a fuel type'**
  String get pleaseSelectFuelType;

  /// No description provided for @pleaseSelectQuantity.
  ///
  /// In en, this message translates to:
  /// **'Please select a quantity'**
  String get pleaseSelectQuantity;

  /// No description provided for @pleaseSelectValidQuantity.
  ///
  /// In en, this message translates to:
  /// **'Please select a valid quantity'**
  String get pleaseSelectValidQuantity;

  /// No description provided for @pricePerLiterDisplay.
  ///
  /// In en, this message translates to:
  /// **'Price per liter: {price} {currency}'**
  String pricePerLiterDisplay(String price, String currency);

  /// No description provided for @liters20Qty.
  ///
  /// In en, this message translates to:
  /// **'20 Liters'**
  String get liters20Qty;

  /// No description provided for @liters30Qty.
  ///
  /// In en, this message translates to:
  /// **'30 Liters'**
  String get liters30Qty;

  /// No description provided for @liters40Qty.
  ///
  /// In en, this message translates to:
  /// **'40 Liters'**
  String get liters40Qty;

  /// No description provided for @liters50Qty.
  ///
  /// In en, this message translates to:
  /// **'50 Liters'**
  String get liters50Qty;

  /// No description provided for @fullTankQty.
  ///
  /// In en, this message translates to:
  /// **'Full Tank'**
  String get fullTankQty;

  /// No description provided for @notifOrderAcceptedTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Accepted'**
  String get notifOrderAcceptedTitle;

  /// No description provided for @notifOrderAcceptedBody.
  ///
  /// In en, this message translates to:
  /// **'The provider accepted your order and will be there soon.'**
  String get notifOrderAcceptedBody;

  /// No description provided for @notifProviderEnRouteTitle.
  ///
  /// In en, this message translates to:
  /// **'Provider On the Way'**
  String get notifProviderEnRouteTitle;

  /// No description provided for @notifProviderEnRouteBody.
  ///
  /// In en, this message translates to:
  /// **'The provider is heading to your location.'**
  String get notifProviderEnRouteBody;

  /// No description provided for @notifProviderArrivedTitle.
  ///
  /// In en, this message translates to:
  /// **'Provider Arrived'**
  String get notifProviderArrivedTitle;

  /// No description provided for @notifProviderArrivedBody.
  ///
  /// In en, this message translates to:
  /// **'The provider has arrived at your location.'**
  String get notifProviderArrivedBody;

  /// No description provided for @notifServiceStartedTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Started'**
  String get notifServiceStartedTitle;

  /// No description provided for @notifFuelServiceBody.
  ///
  /// In en, this message translates to:
  /// **'Fuel delivery in progress.'**
  String get notifFuelServiceBody;

  /// No description provided for @notifTowServiceBody.
  ///
  /// In en, this message translates to:
  /// **'Vehicle towing in progress.'**
  String get notifTowServiceBody;

  /// No description provided for @notifOrderCancelledTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Cancelled'**
  String get notifOrderCancelledTitle;

  /// No description provided for @notifOrderCancelledBody.
  ///
  /// In en, this message translates to:
  /// **'Your order was cancelled by the provider.'**
  String get notifOrderCancelledBody;

  /// No description provided for @notifServiceCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Completed'**
  String get notifServiceCompletedTitle;

  /// No description provided for @notifFuelCompletedBody.
  ///
  /// In en, this message translates to:
  /// **'Fuel delivered successfully.'**
  String get notifFuelCompletedBody;

  /// No description provided for @notifTowCompletedBody.
  ///
  /// In en, this message translates to:
  /// **'Vehicle delivered successfully.'**
  String get notifTowCompletedBody;

  /// No description provided for @driverArrivedTitle.
  ///
  /// In en, this message translates to:
  /// **'Driver arrived at your location.'**
  String get driverArrivedTitle;

  /// No description provided for @loadingSecuringVehicle.
  ///
  /// In en, this message translates to:
  /// **'Loading and securing the vehicle on the tow truck for the trip to your destination.'**
  String get loadingSecuringVehicle;

  /// No description provided for @refuelingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Refueling in Progress'**
  String get refuelingInProgress;

  /// No description provided for @providerRefuelingBody.
  ///
  /// In en, this message translates to:
  /// **'The provider is refueling your vehicle. Please wait until the process is complete.'**
  String get providerRefuelingBody;

  /// No description provided for @cashMethod.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cashMethod;

  /// No description provided for @selectedLocation.
  ///
  /// In en, this message translates to:
  /// **'Selected location'**
  String get selectedLocation;

  /// No description provided for @towDriverRole.
  ///
  /// In en, this message translates to:
  /// **'Tow Driver'**
  String get towDriverRole;

  /// No description provided for @fuelDriverRole.
  ///
  /// In en, this message translates to:
  /// **'Fuel Driver'**
  String get fuelDriverRole;

  /// No description provided for @fuelPatrol.
  ///
  /// In en, this message translates to:
  /// **'Fuel Patrol'**
  String get fuelPatrol;

  /// No description provided for @towingPatrol.
  ///
  /// In en, this message translates to:
  /// **'Towing Patrol'**
  String get towingPatrol;

  /// No description provided for @activeTowOrder.
  ///
  /// In en, this message translates to:
  /// **'Active Tow Order'**
  String get activeTowOrder;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @pendingReview.
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get pendingReview;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @switchLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get switchLanguageTitle;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed'**
  String get languageChanged;

  /// No description provided for @searchKeywordFuel.
  ///
  /// In en, this message translates to:
  /// **'fuel,gas,petrol,diesel,fill,delivery'**
  String get searchKeywordFuel;

  /// No description provided for @searchKeywordTow.
  ///
  /// In en, this message translates to:
  /// **'tow,towing,pull,transport,vehicle,car'**
  String get searchKeywordTow;

  /// No description provided for @searchKeywordOrders.
  ///
  /// In en, this message translates to:
  /// **'orders,order,history,recent'**
  String get searchKeywordOrders;

  /// No description provided for @searchKeywordDiscount.
  ///
  /// In en, this message translates to:
  /// **'discount,code,coupon,offer,deal'**
  String get searchKeywordDiscount;

  /// No description provided for @searchKeywordFAQ.
  ///
  /// In en, this message translates to:
  /// **'question,questions,help,how'**
  String get searchKeywordFAQ;

  /// No description provided for @searchKeywordProfile.
  ///
  /// In en, this message translates to:
  /// **'edit,profile,name,phone,number,account'**
  String get searchKeywordProfile;

  /// No description provided for @searchKeywordTerms.
  ///
  /// In en, this message translates to:
  /// **'terms,conditions,policy'**
  String get searchKeywordTerms;

  /// No description provided for @searchKeywordSupport.
  ///
  /// In en, this message translates to:
  /// **'support,help,contact,complaint'**
  String get searchKeywordSupport;

  /// No description provided for @fuelTypesNotLoaded.
  ///
  /// In en, this message translates to:
  /// **'Fuel types not loaded. Tap to retry.'**
  String get fuelTypesNotLoaded;

  /// No description provided for @searchingForTowProvider.
  ///
  /// In en, this message translates to:
  /// **'Finding the nearest tow driver'**
  String get searchingForTowProvider;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccess;

  /// No description provided for @allServices.
  ///
  /// In en, this message translates to:
  /// **'All Services'**
  String get allServices;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @tryDifferentSearch.
  ///
  /// In en, this message translates to:
  /// **'Try a different search term'**
  String get tryDifferentSearch;

  /// No description provided for @serviceProviderDefault.
  ///
  /// In en, this message translates to:
  /// **'Service Provider'**
  String get serviceProviderDefault;

  /// No description provided for @providerInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Provider Information'**
  String get providerInfoTitle;

  /// No description provided for @ratingCountLabel.
  ///
  /// In en, this message translates to:
  /// **'({count} ratings)'**
  String ratingCountLabel(String count);

  /// No description provided for @safetyFirstTitle.
  ///
  /// In en, this message translates to:
  /// **'Your safety comes first...'**
  String get safetyFirstTitle;

  /// No description provided for @safetyFirstBody.
  ///
  /// In en, this message translates to:
  /// **' If you are in an unsafe location, please move to a better spot or call emergency services immediately.'**
  String get safetyFirstBody;

  /// No description provided for @searchCityOrArea.
  ///
  /// In en, this message translates to:
  /// **'Search for a city or area...'**
  String get searchCityOrArea;

  /// No description provided for @notifChannelName.
  ///
  /// In en, this message translates to:
  /// **'Order Notifications'**
  String get notifChannelName;

  /// No description provided for @notifChannelDesc.
  ///
  /// In en, this message translates to:
  /// **'Notifications for fuel and tow order status'**
  String get notifChannelDesc;

  /// No description provided for @searchingFuelOrders.
  ///
  /// In en, this message translates to:
  /// **'Looking for fuel orders...'**
  String get searchingFuelOrders;

  /// No description provided for @searchingTowOrders.
  ///
  /// In en, this message translates to:
  /// **'Looking for tow requests...'**
  String get searchingTowOrders;

  /// No description provided for @stopPatrol.
  ///
  /// In en, this message translates to:
  /// **'Stop Patrol'**
  String get stopPatrol;

  /// No description provided for @tapToStartOrders.
  ///
  /// In en, this message translates to:
  /// **'Tap to start receiving orders'**
  String get tapToStartOrders;

  /// No description provided for @startButton.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startButton;

  /// No description provided for @orderCancelledSuccessSnack.
  ///
  /// In en, this message translates to:
  /// **'Order cancelled successfully'**
  String get orderCancelledSuccessSnack;

  /// No description provided for @orderCancelledByCustomerSnack.
  ///
  /// In en, this message translates to:
  /// **'Order cancelled by the customer'**
  String get orderCancelledByCustomerSnack;

  /// No description provided for @cancelOrderDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancelOrderDialogTitle;

  /// No description provided for @cancelOrderDialogSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this order?\nThe customer will be notified.'**
  String get cancelOrderDialogSubtitle;

  /// No description provided for @cancelOrderDialogBtn.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancelOrderDialogBtn;

  /// No description provided for @cancelOrderDialogGoBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get cancelOrderDialogGoBack;

  /// No description provided for @activeFuelOrder.
  ///
  /// In en, this message translates to:
  /// **'Active Fuel Order'**
  String get activeFuelOrder;

  /// No description provided for @resumeOrderBtn.
  ///
  /// In en, this message translates to:
  /// **'Resume Order'**
  String get resumeOrderBtn;

  /// No description provided for @statusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get statusAccepted;

  /// No description provided for @statusEnRouteToCustomer.
  ///
  /// In en, this message translates to:
  /// **'En Route to Customer'**
  String get statusEnRouteToCustomer;

  /// No description provided for @statusRefueling.
  ///
  /// In en, this message translates to:
  /// **'Refueling'**
  String get statusRefueling;

  /// No description provided for @statusArrived.
  ///
  /// In en, this message translates to:
  /// **'Arrived'**
  String get statusArrived;

  /// No description provided for @statusCollecting.
  ///
  /// In en, this message translates to:
  /// **'Collecting Payment'**
  String get statusCollecting;

  /// No description provided for @statusInProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get statusInProgressLabel;

  /// No description provided for @fuelDeliveryDriver.
  ///
  /// In en, this message translates to:
  /// **'Fuel Delivery Driver'**
  String get fuelDeliveryDriver;

  /// No description provided for @towTruckDriverRole.
  ///
  /// In en, this message translates to:
  /// **'Tow Truck Driver'**
  String get towTruckDriverRole;

  /// No description provided for @theDriver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get theDriver;

  /// No description provided for @customerAddress.
  ///
  /// In en, this message translates to:
  /// **'Customer address'**
  String get customerAddress;

  /// No description provided for @customerDefault.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customerDefault;

  /// No description provided for @newOrderLabel.
  ///
  /// In en, this message translates to:
  /// **'New order'**
  String get newOrderLabel;

  /// No description provided for @secondsAbbrev.
  ///
  /// In en, this message translates to:
  /// **'s'**
  String get secondsAbbrev;

  /// No description provided for @litersUnit.
  ///
  /// In en, this message translates to:
  /// **'L'**
  String get litersUnit;

  /// No description provided for @noRecentOrders.
  ///
  /// In en, this message translates to:
  /// **'No recent orders'**
  String get noRecentOrders;

  /// No description provided for @recentOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent Orders'**
  String get recentOrdersTitle;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @cashLabel.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cashLabel;

  /// No description provided for @notRated.
  ///
  /// In en, this message translates to:
  /// **'Not rated'**
  String get notRated;

  /// No description provided for @tripDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Trip Details'**
  String get tripDetailsTitle;

  /// No description provided for @failedToLoadTripDetails.
  ///
  /// In en, this message translates to:
  /// **'Failed to load trip details'**
  String get failedToLoadTripDetails;

  /// No description provided for @rateTripBtn.
  ///
  /// In en, this message translates to:
  /// **'Rate Trip'**
  String get rateTripBtn;

  /// No description provided for @tripRouteLabel.
  ///
  /// In en, this message translates to:
  /// **'Trip Route'**
  String get tripRouteLabel;

  /// No description provided for @departurePointLabel.
  ///
  /// In en, this message translates to:
  /// **'Pickup Point'**
  String get departurePointLabel;

  /// No description provided for @deliveryDestinationTripLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery Destination'**
  String get deliveryDestinationTripLabel;

  /// No description provided for @carDetailsLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Details'**
  String get carDetailsLabel;

  /// No description provided for @customerInfoLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer Info'**
  String get customerInfoLabel;

  /// No description provided for @paymentSummaryTripLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment Summary'**
  String get paymentSummaryTripLabel;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationLabel;

  /// No description provided for @carLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Location'**
  String get carLocationLabel;

  /// No description provided for @fuelDetailsTrip.
  ///
  /// In en, this message translates to:
  /// **'Fuel Details'**
  String get fuelDetailsTrip;

  /// No description provided for @orderedQuantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Ordered Quantity'**
  String get orderedQuantityLabel;

  /// No description provided for @fuelTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Fuel Type'**
  String get fuelTypeLabel;

  /// No description provided for @pricePerLiterLabel.
  ///
  /// In en, this message translates to:
  /// **'Price per Liter'**
  String get pricePerLiterLabel;

  /// No description provided for @plateNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Plate Number'**
  String get plateNumberLabel;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @gasolineLabel.
  ///
  /// In en, this message translates to:
  /// **'Gasoline'**
  String get gasolineLabel;

  /// No description provided for @dieselLabel.
  ///
  /// In en, this message translates to:
  /// **'Diesel'**
  String get dieselLabel;

  /// No description provided for @currencyDL.
  ///
  /// In en, this message translates to:
  /// **'DL'**
  String get currencyDL;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @fuelSupplyDriver.
  ///
  /// In en, this message translates to:
  /// **'Fuel Supply Driver'**
  String get fuelSupplyDriver;

  /// No description provided for @towDriverLabel.
  ///
  /// In en, this message translates to:
  /// **'Tow Driver'**
  String get towDriverLabel;

  /// No description provided for @totalRatingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Ratings'**
  String get totalRatingsLabel;

  /// No description provided for @completedOrdersLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed Orders'**
  String get completedOrdersLabel;

  /// No description provided for @salaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get salaryLabel;

  /// No description provided for @fixedSalaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Fixed salary:'**
  String get fixedSalaryLabel;

  /// No description provided for @vehicleLabel2.
  ///
  /// In en, this message translates to:
  /// **'Vehicle'**
  String get vehicleLabel2;

  /// No description provided for @vehicleTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get vehicleTypeLabel;

  /// No description provided for @plateNumberVehicle.
  ///
  /// In en, this message translates to:
  /// **'Plate Number'**
  String get plateNumberVehicle;

  /// No description provided for @vehicleImageLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Image'**
  String get vehicleImageLabel;

  /// No description provided for @documentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documentsLabel;

  /// No description provided for @nationalIdLabel.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get nationalIdLabel;

  /// No description provided for @drivingLicenseLabel.
  ///
  /// In en, this message translates to:
  /// **'Driving License'**
  String get drivingLicenseLabel;

  /// No description provided for @acceptedLabel.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get acceptedLabel;

  /// No description provided for @underReviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get underReviewLabel;

  /// No description provided for @requiredLabel.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredLabel;

  /// No description provided for @viewLabel.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get viewLabel;

  /// No description provided for @uploadFileLabel.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get uploadFileLabel;

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// No description provided for @totalOrdersLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get totalOrdersLabel;

  /// No description provided for @totalIncomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Income'**
  String get totalIncomeLabel;

  /// No description provided for @averageRatingLabel.
  ///
  /// In en, this message translates to:
  /// **'Average Rating'**
  String get averageRatingLabel;

  /// No description provided for @todayIncomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Income'**
  String get todayIncomeLabel;

  /// No description provided for @fromYesterdayLabel.
  ///
  /// In en, this message translates to:
  /// **'from yesterday'**
  String get fromYesterdayLabel;

  /// No description provided for @ratingLabel.
  ///
  /// In en, this message translates to:
  /// **'rating'**
  String get ratingLabel;

  /// No description provided for @orderTodayLabel.
  ///
  /// In en, this message translates to:
  /// **'order today'**
  String get orderTodayLabel;

  /// No description provided for @weeklyOrdersLabel.
  ///
  /// In en, this message translates to:
  /// **'Weekly Orders'**
  String get weeklyOrdersLabel;

  /// No description provided for @weeklyAcceptanceRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Weekly Acceptance Rate'**
  String get weeklyAcceptanceRateLabel;

  /// No description provided for @accountUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Your account is under review, please wait for admin approval'**
  String get accountUnderReview;

  /// No description provided for @analyticsNotFound.
  ///
  /// In en, this message translates to:
  /// **'Analytics data not found'**
  String get analyticsNotFound;

  /// No description provided for @failedToLoadReports.
  ///
  /// In en, this message translates to:
  /// **'Failed to load reports'**
  String get failedToLoadReports;

  /// No description provided for @retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryButton;

  /// No description provided for @syncingWithServer.
  ///
  /// In en, this message translates to:
  /// **'Syncing with server…'**
  String get syncingWithServer;

  /// No description provided for @fuelOnItsWay.
  ///
  /// In en, this message translates to:
  /// **'Fuel is on its way'**
  String get fuelOnItsWay;

  /// No description provided for @towOnItsWay.
  ///
  /// In en, this message translates to:
  /// **'Tow truck is on its way'**
  String get towOnItsWay;

  /// No description provided for @tapToView.
  ///
  /// In en, this message translates to:
  /// **'Tap to view'**
  String get tapToView;

  /// No description provided for @live.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;

  /// No description provided for @driverPreparingToArrive.
  ///
  /// In en, this message translates to:
  /// **'Driver is preparing to arrive'**
  String get driverPreparingToArrive;

  /// No description provided for @driverArrivedAtLocation.
  ///
  /// In en, this message translates to:
  /// **'Driver arrived at your location'**
  String get driverArrivedAtLocation;

  /// No description provided for @fuelingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Fueling in progress'**
  String get fuelingInProgress;

  /// No description provided for @towingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Towing in progress'**
  String get towingInProgress;

  /// No description provided for @petrol.
  ///
  /// In en, this message translates to:
  /// **'Gasoline'**
  String get petrol;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutes;

  /// No description provided for @connectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get connectionFailed;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyPolicyAppTitle.
  ///
  /// In en, this message translates to:
  /// **'GO FULL — Privacy Policy'**
  String get privacyPolicyAppTitle;

  /// No description provided for @privacyPolicyLastUpdate.
  ///
  /// In en, this message translates to:
  /// **'Last updated: April 2026'**
  String get privacyPolicyLastUpdate;

  /// No description provided for @privacyPolicyFooter.
  ///
  /// In en, this message translates to:
  /// **'© 2026 GO FULL. All rights reserved.'**
  String get privacyPolicyFooter;

  /// No description provided for @privacyIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get privacyIntroTitle;

  /// No description provided for @privacyIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the GO FULL Drivers app. We value your privacy and are committed to protecting your personal data. This policy explains how we collect, use, and protect your information when using our services as a driver or service provider.'**
  String get privacyIntroBody;

  /// No description provided for @privacyDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Data We Collect'**
  String get privacyDataTitle;

  /// No description provided for @privacyDataBody.
  ///
  /// In en, this message translates to:
  /// **'• Name, phone number, and registration data\n• ID and driving license photos\n• Your location during service delivery\n• Order details and financial transactions\n• Vehicle data and insurance information\n• Device information to improve performance'**
  String get privacyDataBody;

  /// No description provided for @privacyUsageTitle.
  ///
  /// In en, this message translates to:
  /// **'How We Use Your Data'**
  String get privacyUsageTitle;

  /// No description provided for @privacyUsageBody.
  ///
  /// In en, this message translates to:
  /// **'• Operating fuel supply and vehicle towing services\n• Locating you to route nearby orders\n• Calculating earnings and processing payments\n• Evaluating service quality and your performance\n• Communicating with you about orders and updates\n• Ensuring transaction safety and security'**
  String get privacyUsageBody;

  /// No description provided for @privacySharingTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Sharing'**
  String get privacySharingTitle;

  /// No description provided for @privacySharingBody.
  ///
  /// In en, this message translates to:
  /// **'• We share your name, phone number, and vehicle info with the customer during an order\n• We share your current location with the customer to track your arrival\n• We do not sell your personal data to any third parties\n• We may share anonymized data for analytical purposes'**
  String get privacySharingBody;

  /// No description provided for @privacyProtectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Protection'**
  String get privacyProtectionTitle;

  /// No description provided for @privacyProtectionBody.
  ///
  /// In en, this message translates to:
  /// **'We use advanced encryption technologies to protect your data. We retain your data only as long as your account is active or as required by law. All information is stored on secure servers with continuous monitoring.'**
  String get privacyProtectionBody;

  /// No description provided for @privacyLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Data'**
  String get privacyLocationTitle;

  /// No description provided for @privacyLocationBody.
  ///
  /// In en, this message translates to:
  /// **'We use your geographic location only while your status is set to \"Available\" or during order execution. You can stop sharing your location at any time by changing your status to \"Unavailable\". Your location is not tracked outside working hours.'**
  String get privacyLocationBody;

  /// No description provided for @privacyRightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Rights'**
  String get privacyRightsTitle;

  /// No description provided for @privacyRightsBody.
  ///
  /// In en, this message translates to:
  /// **'• Request access to your personal data\n• Request correction or update of your data\n• Request deletion of your account and data\n• Withdraw your consent at any time\n• File a complaint with relevant authorities'**
  String get privacyRightsBody;

  /// No description provided for @privacyContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get privacyContactTitle;

  /// No description provided for @privacyContactBody.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about the privacy policy or how your data is handled, please contact us through the in-app support section or email us at: support@gofull.ly'**
  String get privacyContactBody;

  /// No description provided for @customerLocationMarker.
  ///
  /// In en, this message translates to:
  /// **'Customer Location'**
  String get customerLocationMarker;

  /// No description provided for @deliveryPointMarker.
  ///
  /// In en, this message translates to:
  /// **'Delivery Point'**
  String get deliveryPointMarker;

  /// No description provided for @myLocationMarker.
  ///
  /// In en, this message translates to:
  /// **'My Location'**
  String get myLocationMarker;

  /// No description provided for @remainingDistance.
  ///
  /// In en, this message translates to:
  /// **'Remaining distance:'**
  String get remainingDistance;

  /// No description provided for @arrivedStartRefueling.
  ///
  /// In en, this message translates to:
  /// **'Arrived — Start Refueling'**
  String get arrivedStartRefueling;

  /// No description provided for @cancelOrderLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancelOrderLabel;

  /// No description provided for @docMandatoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Take a clear photo of the vehicle before starting the transport. This documentation protects both you and the customer.'**
  String get docMandatoryDesc;

  /// No description provided for @captureVehiclePhoto.
  ///
  /// In en, this message translates to:
  /// **'Capture Vehicle Photo'**
  String get captureVehiclePhoto;

  /// No description provided for @tapToCapturePhoto.
  ///
  /// In en, this message translates to:
  /// **'Tap here to open the camera and take a clear photo'**
  String get tapToCapturePhoto;

  /// No description provided for @photoCaptured.
  ///
  /// In en, this message translates to:
  /// **'Photo captured'**
  String get photoCaptured;

  /// No description provided for @pleaseCaptureToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please capture a photo of the vehicle to continue'**
  String get pleaseCaptureToContinue;

  /// No description provided for @refuelingTitle.
  ///
  /// In en, this message translates to:
  /// **'Refueling'**
  String get refuelingTitle;

  /// No description provided for @refuelingInProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Refueling in Progress'**
  String get refuelingInProgressTitle;

  /// No description provided for @refuelingInstructions.
  ///
  /// In en, this message translates to:
  /// **'Refuel the vehicle according to the quantity specified in the order'**
  String get refuelingInstructions;

  /// No description provided for @refuelingGuide.
  ///
  /// In en, this message translates to:
  /// **'Refueling Instructions'**
  String get refuelingGuide;

  /// No description provided for @refuelingStep1.
  ///
  /// In en, this message translates to:
  /// **'Make sure the engine is turned off before refueling'**
  String get refuelingStep1;

  /// No description provided for @refuelingStep2.
  ///
  /// In en, this message translates to:
  /// **'Refuel the exact quantity specified in the order'**
  String get refuelingStep2;

  /// No description provided for @refuelingStep3.
  ///
  /// In en, this message translates to:
  /// **'Close the fuel cap tightly after finishing'**
  String get refuelingStep3;

  /// No description provided for @refuelingDoneCollect.
  ///
  /// In en, this message translates to:
  /// **'Refueling Done — Collect Payment'**
  String get refuelingDoneCollect;

  /// No description provided for @currencyEGP.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get currencyEGP;

  /// No description provided for @backToHomeBtn.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHomeBtn;

  /// No description provided for @technicalSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Technical Support'**
  String get technicalSupportTitle;

  /// No description provided for @supportTeamAvailable.
  ///
  /// In en, this message translates to:
  /// **'Support team is available to help'**
  String get supportTeamAvailable;

  /// No description provided for @directCallLabel.
  ///
  /// In en, this message translates to:
  /// **'Direct Call'**
  String get directCallLabel;

  /// No description provided for @phoneNumberLabel2.
  ///
  /// In en, this message translates to:
  /// **'Phone:'**
  String get phoneNumberLabel2;

  /// No description provided for @numberCopiedSnack.
  ///
  /// In en, this message translates to:
  /// **'Number copied'**
  String get numberCopiedSnack;

  /// No description provided for @acceptRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Acceptance Rate'**
  String get acceptRateLabel;

  /// No description provided for @fuelCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Refueling Complete'**
  String get fuelCompleteTitle;

  /// No description provided for @fuelCompleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your vehicle has been refueled successfully!'**
  String get fuelCompleteSuccess;

  /// No description provided for @fuelCompleteSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fuel has been delivered successfully. Please make sure the fuel cap is closed and the vehicle is safe.'**
  String get fuelCompleteSubtitle;

  /// No description provided for @safetyGuidelines.
  ///
  /// In en, this message translates to:
  /// **'Safety Guidelines'**
  String get safetyGuidelines;

  /// No description provided for @hideAll.
  ///
  /// In en, this message translates to:
  /// **'Hide All'**
  String get hideAll;

  /// No description provided for @howWasYourExperience.
  ///
  /// In en, this message translates to:
  /// **'How was your experience?'**
  String get howWasYourExperience;

  /// No description provided for @feedbackHelpsImprove.
  ///
  /// In en, this message translates to:
  /// **'Your feedback helps us improve our service quality and driver performance.'**
  String get feedbackHelpsImprove;

  /// No description provided for @thankYouForRating.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your rating!'**
  String get thankYouForRating;

  /// No description provided for @ratingSubmittedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your rating has been submitted successfully. Thank you for helping us improve.'**
  String get ratingSubmittedSuccess;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @serviceDetails.
  ///
  /// In en, this message translates to:
  /// **'Service Details'**
  String get serviceDetails;

  /// No description provided for @actualQuantity.
  ///
  /// In en, this message translates to:
  /// **'Actual Quantity'**
  String get actualQuantity;

  /// No description provided for @todayPricePerLiter.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Price per Liter'**
  String get todayPricePerLiter;

  /// No description provided for @providerDetails.
  ///
  /// In en, this message translates to:
  /// **'Provider Details'**
  String get providerDetails;

  /// No description provided for @yourRating.
  ///
  /// In en, this message translates to:
  /// **'Your Rating'**
  String get yourRating;

  /// No description provided for @safetyItemTankCap.
  ///
  /// In en, this message translates to:
  /// **'Tank cap: Make sure the fuel cap is tightly closed.'**
  String get safetyItemTankCap;

  /// No description provided for @safetyItemInspection.
  ///
  /// In en, this message translates to:
  /// **'Final inspection: Make sure there are no fuel spills around the car.'**
  String get safetyItemInspection;

  /// No description provided for @safetyItemPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment: Please pay the total amount to the driver (cash) or through the app.'**
  String get safetyItemPayment;

  /// No description provided for @fullTankFill.
  ///
  /// In en, this message translates to:
  /// **'Full tank fill'**
  String get fullTankFill;

  /// No description provided for @gasolineFuel.
  ///
  /// In en, this message translates to:
  /// **'Gasoline'**
  String get gasolineFuel;

  /// No description provided for @dieselFuel.
  ///
  /// In en, this message translates to:
  /// **'Diesel'**
  String get dieselFuel;

  /// No description provided for @searchForLocation.
  ///
  /// In en, this message translates to:
  /// **'Search for your location'**
  String get searchForLocation;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @searchForLocationDots.
  ///
  /// In en, this message translates to:
  /// **'Search for a location...'**
  String get searchForLocationDots;

  /// No description provided for @selectedLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Selected location'**
  String get selectedLocationLabel;

  /// No description provided for @searchForCityOrDistrict.
  ///
  /// In en, this message translates to:
  /// **'Search for a city or district...'**
  String get searchForCityOrDistrict;

  /// No description provided for @loadingLocation.
  ///
  /// In en, this message translates to:
  /// **'Locating...'**
  String get loadingLocation;

  /// No description provided for @moveMapToSelectLocation.
  ///
  /// In en, this message translates to:
  /// **'Move the map to select your location'**
  String get moveMapToSelectLocation;

  /// No description provided for @yourLocation.
  ///
  /// In en, this message translates to:
  /// **'Your location'**
  String get yourLocation;

  /// No description provided for @selectLocationOnMapAlt.
  ///
  /// In en, this message translates to:
  /// **'Select location on map'**
  String get selectLocationOnMapAlt;

  /// No description provided for @noActiveCoupons.
  ///
  /// In en, this message translates to:
  /// **'No active coupons'**
  String get noActiveCoupons;

  /// No description provided for @noExpiredCoupons.
  ///
  /// In en, this message translates to:
  /// **'No expired coupons'**
  String get noExpiredCoupons;

  /// No description provided for @haveDiscountCode.
  ///
  /// In en, this message translates to:
  /// **'Have a discount code?'**
  String get haveDiscountCode;

  /// No description provided for @enterDiscountCode.
  ///
  /// In en, this message translates to:
  /// **'Enter discount code..'**
  String get enterDiscountCode;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @savingsList.
  ///
  /// In en, this message translates to:
  /// **'Savings List'**
  String get savingsList;

  /// No description provided for @previousCodes.
  ///
  /// In en, this message translates to:
  /// **'Previous Codes'**
  String get previousCodes;

  /// No description provided for @useCoupon.
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get useCoupon;

  /// No description provided for @confirmNewNumber.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Number'**
  String get confirmNewNumber;

  /// No description provided for @enterSmsCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the code we sent via SMS to '**
  String get enterSmsCode;

  /// No description provided for @changeNumber.
  ///
  /// In en, this message translates to:
  /// **'Change Number'**
  String get changeNumber;

  /// No description provided for @didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code? '**
  String get didntReceiveCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @resendCodeIn.
  ///
  /// In en, this message translates to:
  /// **'Resend code in '**
  String get resendCodeIn;

  /// No description provided for @confirmNumber.
  ///
  /// In en, this message translates to:
  /// **'Confirm Number'**
  String get confirmNumber;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @deleteAccountBtn.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountBtn;

  /// No description provided for @editBtn.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editBtn;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get whatsapp;

  /// No description provided for @whatsappChat.
  ///
  /// In en, this message translates to:
  /// **'Instant chat with support team'**
  String get whatsappChat;

  /// No description provided for @howCanWeHelp.
  ///
  /// In en, this message translates to:
  /// **'How can we help you?'**
  String get howCanWeHelp;

  /// No description provided for @teamReadyToServe.
  ///
  /// In en, this message translates to:
  /// **'Our team is ready to serve you'**
  String get teamReadyToServe;

  /// No description provided for @faqHowFuel.
  ///
  /// In en, this message translates to:
  /// **'How do I order fuel service?'**
  String get faqHowFuel;

  /// No description provided for @faqHowFuelAnswer.
  ///
  /// In en, this message translates to:
  /// **'From the home screen, select \'Fuel\' then choose the fuel type, quantity and your location, and a provider will be sent to you.'**
  String get faqHowFuelAnswer;

  /// No description provided for @faqHowTow.
  ///
  /// In en, this message translates to:
  /// **'How do I order towing service?'**
  String get faqHowTow;

  /// No description provided for @faqHowTowAnswer.
  ///
  /// In en, this message translates to:
  /// **'From the home screen, select \'Tow Truck\' then specify the pickup and delivery locations and enter vehicle details.'**
  String get faqHowTowAnswer;

  /// No description provided for @faqCanCancel.
  ///
  /// In en, this message translates to:
  /// **'Can I cancel an order?'**
  String get faqCanCancel;

  /// No description provided for @faqCanCancelAnswer.
  ///
  /// In en, this message translates to:
  /// **'Yes, you can cancel the order before it\'s accepted by the provider by pressing the cancel button.'**
  String get faqCanCancelAnswer;

  /// No description provided for @faqPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'What payment methods are available?'**
  String get faqPaymentMethods;

  /// No description provided for @faqPaymentMethodsAnswer.
  ///
  /// In en, this message translates to:
  /// **'Currently, payment is made in cash upon service completion.'**
  String get faqPaymentMethodsAnswer;

  /// No description provided for @faqTripCost.
  ///
  /// In en, this message translates to:
  /// **'How is the trip cost determined?'**
  String get faqTripCost;

  /// No description provided for @faqTripCostAnswer.
  ///
  /// In en, this message translates to:
  /// **'The cost is calculated based on the selected service type, distance traveled (for towing), and a fixed service fee. An estimated price is shown before confirming the order.'**
  String get faqTripCostAnswer;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get version;

  /// No description provided for @aboutFuelTitle.
  ///
  /// In en, this message translates to:
  /// **'Fuel Delivery'**
  String get aboutFuelTitle;

  /// No description provided for @aboutFuelDesc.
  ///
  /// In en, this message translates to:
  /// **'Fuel delivery service directly to your location. Gasoline or diesel, we deliver wherever you are.'**
  String get aboutFuelDesc;

  /// No description provided for @aboutTowTitle.
  ///
  /// In en, this message translates to:
  /// **'Tow Truck Service'**
  String get aboutTowTitle;

  /// No description provided for @aboutTowDesc.
  ///
  /// In en, this message translates to:
  /// **'Fast towing and rescue for your car. A specialized and equipped team to transport your vehicle safely.'**
  String get aboutTowDesc;

  /// No description provided for @aboutFastResponse.
  ///
  /// In en, this message translates to:
  /// **'Fast Response'**
  String get aboutFastResponse;

  /// No description provided for @aboutFastResponseDesc.
  ///
  /// In en, this message translates to:
  /// **'We connect you with the nearest service provider in your area to ensure help arrives as quickly as possible.'**
  String get aboutFastResponseDesc;

  /// No description provided for @aboutSafety.
  ///
  /// In en, this message translates to:
  /// **'Safety & Reliability'**
  String get aboutSafety;

  /// No description provided for @aboutSafetyDesc.
  ///
  /// In en, this message translates to:
  /// **'All service providers are verified and approved. Transparent ratings to ensure service quality.'**
  String get aboutSafetyDesc;

  /// No description provided for @copyright.
  ///
  /// In en, this message translates to:
  /// **'2026 GO FULL. All rights reserved.'**
  String get copyright;

  /// No description provided for @searchServiceHelp.
  ///
  /// In en, this message translates to:
  /// **'Search for a service, order, or help...'**
  String get searchServiceHelp;

  /// No description provided for @useCodePrefix.
  ///
  /// In en, this message translates to:
  /// **'Use code: '**
  String get useCodePrefix;

  /// No description provided for @serviceFeeDeliveryNote.
  ///
  /// In en, this message translates to:
  /// **'Service and delivery fees will be added to the fuel price.'**
  String get serviceFeeDeliveryNote;

  /// No description provided for @selectFuelTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Select fuel type'**
  String get selectFuelTypeHint;

  /// No description provided for @selectQuantityHint.
  ///
  /// In en, this message translates to:
  /// **'Select quantity'**
  String get selectQuantityHint;

  /// No description provided for @deliveryDestinationAlt.
  ///
  /// In en, this message translates to:
  /// **'Delivery destination'**
  String get deliveryDestinationAlt;

  /// No description provided for @towServiceLabel.
  ///
  /// In en, this message translates to:
  /// **'Tow Service'**
  String get towServiceLabel;

  /// No description provided for @inProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgressLabel;

  /// No description provided for @cancelledLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelledLabel;

  /// No description provided for @completedLabel.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedLabel;

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity: '**
  String get quantityLabel;

  /// No description provided for @carTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Type'**
  String get carTypeLabel;

  /// No description provided for @towTruckType.
  ///
  /// In en, this message translates to:
  /// **'Tow Truck Type'**
  String get towTruckType;

  /// No description provided for @supportAndHelp.
  ///
  /// In en, this message translates to:
  /// **'Support & Help'**
  String get supportAndHelp;

  /// No description provided for @privacyPolicyIntroTitle.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get privacyPolicyIntroTitle;

  /// No description provided for @privacyPolicyIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Welcome to GO FULL app. We value your privacy and are committed to protecting your personal data. This policy explains how we collect, use and protect your information when using our services.'**
  String get privacyPolicyIntroBody;

  /// No description provided for @privacyDataCollectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Data We Collect'**
  String get privacyDataCollectedTitle;

  /// No description provided for @privacyDataCollectedBody.
  ///
  /// In en, this message translates to:
  /// **'- Name and phone number at registration\n- Your geographic location to determine the service point\n- Order and transaction details\n- Device information to improve performance'**
  String get privacyDataCollectedBody;

  /// No description provided for @privacyDataUseTitle.
  ///
  /// In en, this message translates to:
  /// **'How We Use Your Data'**
  String get privacyDataUseTitle;

  /// No description provided for @privacyDataUseBody.
  ///
  /// In en, this message translates to:
  /// **'- Providing fuel delivery and towing services\n- Improving service quality and user experience\n- Communicating with you about your orders\n- Ensuring transaction security and safety'**
  String get privacyDataUseBody;

  /// No description provided for @termsGeneralTitle.
  ///
  /// In en, this message translates to:
  /// **'1. General'**
  String get termsGeneralTitle;

  /// No description provided for @termsGeneralBody.
  ///
  /// In en, this message translates to:
  /// **'By using the GO FULL app, you agree to comply with all the terms mentioned here to ensure the best experience.\nWe reserve the right to update these terms from time to time, and you will be notified of any material changes.'**
  String get termsGeneralBody;

  /// No description provided for @termsOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'2. Orders & Pricing'**
  String get termsOrdersTitle;

  /// No description provided for @termsOrdersBody.
  ///
  /// In en, this message translates to:
  /// **'Product prices are the same as the store prices at the time of ordering, with exclusive offers available within the app.\nFor weight-based products, the final price may vary slightly based on actual weight at preparation time, and any difference is automatically settled in your wallet.\nThe app reserves the right to cancel the order if the product is unavailable or there is a pricing error, with a commitment to refund any amounts paid to your wallet.'**
  String get termsOrdersBody;

  /// No description provided for @termsDeliveryTitle.
  ///
  /// In en, this message translates to:
  /// **'3. Delivery'**
  String get termsDeliveryTitle;

  /// No description provided for @termsDeliveryBody.
  ///
  /// In en, this message translates to:
  /// **'We strive to deliver your order on time (45 to 90 minutes), but the time may be affected by circumstances beyond our control such as traffic or weather.\nThe customer or their representative must be present at the specified address to receive the order. If we cannot reach you, the order may be cancelled with delivery charges applied.'**
  String get termsDeliveryBody;

  /// No description provided for @termsWalletTitle.
  ///
  /// In en, this message translates to:
  /// **'4. Wallet & Refunds'**
  String get termsWalletTitle;

  /// No description provided for @termsWalletBody.
  ///
  /// In en, this message translates to:
  /// **'Wallet balances come from (top-ups, weight difference refunds, or product compensations), and can be used for your future orders.'**
  String get termsWalletBody;

  /// No description provided for @failedLoadNotifications.
  ///
  /// In en, this message translates to:
  /// **'Failed to load notifications'**
  String get failedLoadNotifications;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedError;

  /// No description provided for @failedLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get failedLoadProfile;

  /// No description provided for @failedUpdateStatus.
  ///
  /// In en, this message translates to:
  /// **'Failed to update status'**
  String get failedUpdateStatus;

  /// No description provided for @failedLoadRequests.
  ///
  /// In en, this message translates to:
  /// **'Failed to load requests'**
  String get failedLoadRequests;

  /// No description provided for @failedLoadHistory.
  ///
  /// In en, this message translates to:
  /// **'Failed to load history'**
  String get failedLoadHistory;

  /// No description provided for @failedAcceptRequest.
  ///
  /// In en, this message translates to:
  /// **'Failed to accept request'**
  String get failedAcceptRequest;

  /// No description provided for @failedRejectRequest.
  ///
  /// In en, this message translates to:
  /// **'Failed to reject request'**
  String get failedRejectRequest;

  /// No description provided for @failedSubmitRating.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit rating'**
  String get failedSubmitRating;

  /// No description provided for @failedLoadActiveRequest.
  ///
  /// In en, this message translates to:
  /// **'Failed to load active request'**
  String get failedLoadActiveRequest;

  /// No description provided for @failedCancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel order'**
  String get failedCancelOrder;

  /// No description provided for @failedUploadFile.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload file'**
  String get failedUploadFile;

  /// No description provided for @requestedQuantity.
  ///
  /// In en, this message translates to:
  /// **'Requested Quantity'**
  String get requestedQuantity;

  /// No description provided for @orderConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Order Confirmation'**
  String get orderConfirmation;

  /// No description provided for @onTheWayToYou.
  ///
  /// In en, this message translates to:
  /// **'On the way to you'**
  String get onTheWayToYou;

  /// No description provided for @driverAcceptedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The driver accepted your request and is now on the way to you.'**
  String get driverAcceptedSubtitle;

  /// No description provided for @providerFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Service provider found!'**
  String get providerFoundTitle;

  /// No description provided for @orderCancelledByProviderSearchAgain.
  ///
  /// In en, this message translates to:
  /// **'Order cancelled by service provider. We will search for another provider.'**
  String get orderCancelledByProviderSearchAgain;

  /// No description provided for @providerOnTheWayTitle.
  ///
  /// In en, this message translates to:
  /// **'Provider on the way'**
  String get providerOnTheWayTitle;

  /// No description provided for @fuelProviderMovedToYou.
  ///
  /// In en, this message translates to:
  /// **'Fuel provider is heading to your location'**
  String get fuelProviderMovedToYou;

  /// No description provided for @towDriverMovedToYou.
  ///
  /// In en, this message translates to:
  /// **'Tow driver is heading to your location'**
  String get towDriverMovedToYou;

  /// No description provided for @providerArrivedAtLocation.
  ///
  /// In en, this message translates to:
  /// **'Service provider arrived at your location'**
  String get providerArrivedAtLocation;

  /// No description provided for @serviceStarted.
  ///
  /// In en, this message translates to:
  /// **'Service started'**
  String get serviceStarted;

  /// No description provided for @serviceCompletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Service completed successfully'**
  String get serviceCompletedSuccessfully;

  /// No description provided for @orderStatusUpdate.
  ///
  /// In en, this message translates to:
  /// **'Order status update'**
  String get orderStatusUpdate;

  /// No description provided for @fuelProviderOnWayToYou.
  ///
  /// In en, this message translates to:
  /// **'Fuel provider is on the way to you'**
  String get fuelProviderOnWayToYou;

  /// No description provided for @towDriverOnWayToYou.
  ///
  /// In en, this message translates to:
  /// **'Tow driver is on the way to you'**
  String get towDriverOnWayToYou;

  /// No description provided for @driverMovedWaitSafe.
  ///
  /// In en, this message translates to:
  /// **'The driver is heading to your location. Please wait in a safe place.'**
  String get driverMovedWaitSafe;

  /// No description provided for @fuelRequestAccepted.
  ///
  /// In en, this message translates to:
  /// **'Fuel request accepted'**
  String get fuelRequestAccepted;

  /// No description provided for @towRequestAccepted.
  ///
  /// In en, this message translates to:
  /// **'Tow request accepted'**
  String get towRequestAccepted;

  /// No description provided for @providerOnWayToYouName.
  ///
  /// In en, this message translates to:
  /// **'Provider {name} is on the way to you'**
  String providerOnWayToYouName(String name);

  /// No description provided for @fuelProviderFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Fuel provider found!'**
  String get fuelProviderFoundTitle;

  /// No description provided for @towTruckFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Tow truck found!'**
  String get towTruckFoundTitle;

  /// No description provided for @towTruckTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Tow Truck Type'**
  String get towTruckTypeLabel;

  /// No description provided for @waitSafeLocation.
  ///
  /// In en, this message translates to:
  /// **'Please wait in a safe place away from traffic and turn on your hazard lights until the driver arrives.'**
  String get waitSafeLocation;

  /// No description provided for @refuelingInProgressHeader.
  ///
  /// In en, this message translates to:
  /// **'Refueling in Progress'**
  String get refuelingInProgressHeader;

  /// No description provided for @orderCancelledTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Cancelled'**
  String get orderCancelledTitle;

  /// No description provided for @orderCancelledByProviderBody.
  ///
  /// In en, this message translates to:
  /// **'Your order was cancelled by the service provider'**
  String get orderCancelledByProviderBody;

  /// No description provided for @fuelCompletedBody.
  ///
  /// In en, this message translates to:
  /// **'Your car has been refueled successfully'**
  String get fuelCompletedBody;

  /// No description provided for @towCompletedBody.
  ///
  /// In en, this message translates to:
  /// **'Your car has been towed successfully'**
  String get towCompletedBody;

  /// No description provided for @towingStartHeader.
  ///
  /// In en, this message translates to:
  /// **'Towing Started'**
  String get towingStartHeader;

  /// No description provided for @closeWindowsSafety.
  ///
  /// In en, this message translates to:
  /// **'Close windows: Make sure all car windows and openings are closed.'**
  String get closeWindowsSafety;

  /// No description provided for @personalBelongingsSafety.
  ///
  /// In en, this message translates to:
  /// **'Personal belongings: Make sure to take all your personal items from the car.'**
  String get personalBelongingsSafety;

  /// No description provided for @carOnWayToDestination.
  ///
  /// In en, this message translates to:
  /// **'Your car is on its way to the delivery destination.'**
  String get carOnWayToDestination;

  /// No description provided for @carBeingTransported.
  ///
  /// In en, this message translates to:
  /// **'Your car is being transported on the tow truck to your destination.'**
  String get carBeingTransported;

  /// No description provided for @tripInProgressHeader.
  ///
  /// In en, this message translates to:
  /// **'Trip In Progress'**
  String get tripInProgressHeader;

  /// No description provided for @missionCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Mission completed successfully!'**
  String get missionCompletedTitle;

  /// No description provided for @carDroppedOffBody.
  ///
  /// In en, this message translates to:
  /// **'The car has been dropped off at the specified delivery destination. Please verify the car is safe before completing payment.'**
  String get carDroppedOffBody;

  /// No description provided for @ratingHelpsImproveServices.
  ///
  /// In en, this message translates to:
  /// **'Your feedback helps us improve our services and driver performance.'**
  String get ratingHelpsImproveServices;

  /// No description provided for @ratingSubmittedSuccessBody.
  ///
  /// In en, this message translates to:
  /// **'Your rating has been submitted successfully. Thank you for helping us improve.'**
  String get ratingSubmittedSuccessBody;

  /// No description provided for @vehicleArrivalHeader.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Arrival'**
  String get vehicleArrivalHeader;

  /// No description provided for @alreadyRated.
  ///
  /// In en, this message translates to:
  /// **'Already Rated'**
  String get alreadyRated;

  /// No description provided for @etaLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated arrival time: {eta} minutes'**
  String etaLabel(String eta);

  /// No description provided for @callDriver.
  ///
  /// In en, this message translates to:
  /// **'Call Driver'**
  String get callDriver;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessage;

  /// No description provided for @expectedTimeFindDriver.
  ///
  /// In en, this message translates to:
  /// **'Expected time to find a driver: '**
  String get expectedTimeFindDriver;

  /// No description provided for @minutesFormatted.
  ///
  /// In en, this message translates to:
  /// **'{time} minutes'**
  String minutesFormatted(String time);

  /// No description provided for @retakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retakePhoto;

  /// No description provided for @saveAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Save & Continue'**
  String get saveAndContinue;

  /// No description provided for @enterCarType.
  ///
  /// In en, this message translates to:
  /// **'Enter car type'**
  String get enterCarType;

  /// No description provided for @enterPlateNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter plate number'**
  String get enterPlateNumber;

  /// No description provided for @safetySecureCar.
  ///
  /// In en, this message translates to:
  /// **'Secure the car: Please park in a safe, flat area.'**
  String get safetySecureCar;

  /// No description provided for @safetyTurnOffEngine.
  ///
  /// In en, this message translates to:
  /// **'Turn off the engine: Make sure the engine is completely off before refueling.'**
  String get safetyTurnOffEngine;

  /// No description provided for @safetyConfirmType.
  ///
  /// In en, this message translates to:
  /// **'Confirm type: Preparing (Gasoline 95) as per your request.'**
  String get safetyConfirmType;

  /// No description provided for @safetyNoSmoking.
  ///
  /// In en, this message translates to:
  /// **'Safety procedures: Please refrain from smoking in the refueling area.'**
  String get safetyNoSmoking;

  /// No description provided for @safetyCheckCarCondition.
  ///
  /// In en, this message translates to:
  /// **'Check car condition: Please inspect the car carefully for any damage from towing before completing the order.'**
  String get safetyCheckCarCondition;

  /// No description provided for @safetyCheckLocation.
  ///
  /// In en, this message translates to:
  /// **'Check location: Make sure the car is in a safe place and parking is legal to avoid violations.'**
  String get safetyCheckLocation;

  /// No description provided for @safetyCollectBelongings.
  ///
  /// In en, this message translates to:
  /// **'Collect belongings: Ensure you collect your car keys and all personal items from the driver or cabin.'**
  String get safetyCollectBelongings;

  /// No description provided for @safetyDropOffArea.
  ///
  /// In en, this message translates to:
  /// **'Safety at drop-off: If the area is crowded, be careful when moving around the tow truck during unloading.'**
  String get safetyDropOffArea;

  /// No description provided for @safetyFinancialTransaction.
  ///
  /// In en, this message translates to:
  /// **'Financial transaction: Do not pay any extra amounts not shown in the app. Contact support immediately if the driver requests it.'**
  String get safetyFinancialTransaction;

  /// No description provided for @ensureAtDestination.
  ///
  /// In en, this message translates to:
  /// **'Please make sure you are at the delivery destination or someone is available to receive the car when the driver arrives.'**
  String get ensureAtDestination;

  /// No description provided for @showAll.
  ///
  /// In en, this message translates to:
  /// **'Show All'**
  String get showAll;

  /// No description provided for @hideDisplay.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get hideDisplay;

  /// No description provided for @carTypePrefixLabel.
  ///
  /// In en, this message translates to:
  /// **'Car Type: {type}'**
  String carTypePrefixLabel(String type);

  /// No description provided for @plateNumberPrefixLabel.
  ///
  /// In en, this message translates to:
  /// **'Plate Number: {plate}'**
  String plateNumberPrefixLabel(String plate);

  /// No description provided for @kmUnit.
  ///
  /// In en, this message translates to:
  /// **'km'**
  String get kmUnit;

  /// No description provided for @userDefault.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get userDefault;

  /// No description provided for @currencyKWD.
  ///
  /// In en, this message translates to:
  /// **'KWD'**
  String get currencyKWD;

  /// No description provided for @privacyLastUpdate.
  ///
  /// In en, this message translates to:
  /// **'Last update: April 2026'**
  String get privacyLastUpdate;

  /// No description provided for @privacyCopyright.
  ///
  /// In en, this message translates to:
  /// **'© 2026 GO FULL. All rights reserved.'**
  String get privacyCopyright;

  /// No description provided for @privacyDriverIntroBody.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the GO FULL driver app. We value your privacy and are committed to protecting your personal data. This policy explains how we collect, use and protect your information when using our services as a driver or service provider.'**
  String get privacyDriverIntroBody;

  /// No description provided for @privacyDriverDataCollectedTitle.
  ///
  /// In en, this message translates to:
  /// **'Data We Collect'**
  String get privacyDriverDataCollectedTitle;

  /// No description provided for @privacyDriverDataCollectedBody.
  ///
  /// In en, this message translates to:
  /// **'• Name, phone number, and registration data\n• ID photos and driving license\n• Your geographic location during service delivery\n• Order details and financial transactions\n• Vehicle data and insurance information\n• Device information to improve performance'**
  String get privacyDriverDataCollectedBody;

  /// No description provided for @privacyDriverDataUseTitle.
  ///
  /// In en, this message translates to:
  /// **'How We Use Your Data'**
  String get privacyDriverDataUseTitle;

  /// No description provided for @privacyDriverDataUseBody.
  ///
  /// In en, this message translates to:
  /// **'• Operating fuel delivery and vehicle towing services\n• Determining your location to route nearby orders to you\n• Calculating earnings and processing payments\n• Evaluating service quality and your performance\n• Communicating with you about orders and updates\n• Ensuring transaction security and safety'**
  String get privacyDriverDataUseBody;

  /// No description provided for @privacyDriverDataShareTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Sharing'**
  String get privacyDriverDataShareTitle;

  /// No description provided for @privacyDriverDataShareBody.
  ///
  /// In en, this message translates to:
  /// **'• We share your name, phone number and vehicle information with the customer during orders\n• We share your current location with the customer to track your arrival\n• We do not sell your personal data to any third parties\n• We may share anonymized data for analytical purposes'**
  String get privacyDriverDataShareBody;

  /// No description provided for @privacyDriverDataProtectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Protection'**
  String get privacyDriverDataProtectionTitle;

  /// No description provided for @privacyDriverDataProtectionBody.
  ///
  /// In en, this message translates to:
  /// **'We use advanced encryption technologies to protect your data. We retain your data only as long as your account is active or as required by law. All information is stored on secure servers with continuous monitoring.'**
  String get privacyDriverDataProtectionBody;

  /// No description provided for @privacyDriverLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Data'**
  String get privacyDriverLocationTitle;

  /// No description provided for @privacyDriverLocationBody.
  ///
  /// In en, this message translates to:
  /// **'We use your geographic location only when your status is set to \'Available\' or during order execution. You can stop sharing your location at any time by changing your status to \'Unavailable\'. Your location is not tracked outside working hours.'**
  String get privacyDriverLocationBody;

  /// No description provided for @privacyDriverRightsTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Rights'**
  String get privacyDriverRightsTitle;

  /// No description provided for @privacyDriverRightsBody.
  ///
  /// In en, this message translates to:
  /// **'• Request access to your personal data\n• Request correction or update of your data\n• Request deletion of your account and data\n• Withdraw your consent at any time\n• File a complaint with the relevant authorities'**
  String get privacyDriverRightsBody;

  /// No description provided for @privacyDriverContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get privacyDriverContactTitle;

  /// No description provided for @privacyDriverContactBody.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about the privacy policy or how your data is handled, please contact us through the technical support section in the app or email us at: support@gofull.ly'**
  String get privacyDriverContactBody;

  /// No description provided for @fuelDetailsSection.
  ///
  /// In en, this message translates to:
  /// **'Fuel Details'**
  String get fuelDetailsSection;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @themeMode.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeMode;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeChanged.
  ///
  /// In en, this message translates to:
  /// **'Theme updated'**
  String get themeChanged;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @matchSystemTheme.
  ///
  /// In en, this message translates to:
  /// **'Match System Theme'**
  String get matchSystemTheme;

  /// No description provided for @matchSystemThemeDesc.
  ///
  /// In en, this message translates to:
  /// **'The app follows your phone\'s theme automatically'**
  String get matchSystemThemeDesc;

  /// No description provided for @darkThemeToggle.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkThemeToggle;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return SAr();
    case 'en':
      return SEn();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
