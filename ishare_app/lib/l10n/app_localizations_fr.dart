// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get home => 'Accueil';

  @override
  String get find => 'Rechercher';

  @override
  String get trips => 'Trajets';

  @override
  String get profile => 'Profil';

  @override
  String get goodMorning => 'Bonjour,';

  @override
  String get whereToNext => 'Où allez-vous?';

  @override
  String get searchRides => 'Rechercher des trajets';

  @override
  String get currentLocation => 'Position actuelle';

  @override
  String get enterDestination => 'Entrez la destination...';

  @override
  String get quickActions => 'Actions rapides';

  @override
  String get findRide => 'Trouver un trajet';

  @override
  String get bookNow => 'Réserver';

  @override
  String get offerRide => 'Proposer un trajet';

  @override
  String get earnMoney => 'Gagner de l\'argent';

  @override
  String get safetyCenter => 'Centre de sécurité';

  @override
  String get guidelines => 'Directives';

  @override
  String get aboutUs => 'À propos d\'iShare';

  @override
  String get ourStory => 'Notre histoire';

  @override
  String get recommended => 'Recommandé';

  @override
  String get seeAll => 'Voir tout';

  @override
  String get whyIshare => 'Pourquoi iShare ?';

  @override
  String get saveCosts => 'Économisez';

  @override
  String get saveCostsDesc => 'Partagez les coûts de carburant.';

  @override
  String get ecoFriendly => 'Écologique';

  @override
  String get ecoFriendlyDesc => 'Réduisez votre empreinte carbone.';

  @override
  String get community => 'Communauté';

  @override
  String get communityDesc => 'Connectez-vous avec les autres.';

  @override
  String seatsLeft(int count) {
    return '$count places restantes';
  }

  @override
  String get totalPrice => 'Prix total';

  @override
  String get pickUp => 'Point de ramassage';

  @override
  String get dropOff => 'Point de dépôt';

  @override
  String get accountSettings => 'Paramètres du compte';

  @override
  String get contactUs => 'Nous contacter';

  @override
  String get logOut => 'Se déconnecter';

  @override
  String get paymentTitle => 'Paiement';

  @override
  String get verificationRequired => 'Vérification requise';

  @override
  String get verifyAccountMsg =>
      'Veuillez vérifier votre compte avant d\'effectuer le paiement.';

  @override
  String get cancel => 'Annuler';

  @override
  String get verifyNow => 'Vérifier maintenant';

  @override
  String get paymentInitiated => 'Paiement initié';

  @override
  String get checkPhoneMsg =>
      'Veuillez vérifier votre téléphone pour une confirmation de paiement.';

  @override
  String get transactionId => 'ID de transaction';

  @override
  String get amount => 'Montant';

  @override
  String get done => 'Terminé';

  @override
  String get paymentFailed => 'Paiement échoué';

  @override
  String get accountVerified => 'Compte vérifié';

  @override
  String get accountNotVerified => 'Compte non vérifié';

  @override
  String get totalAmount => 'Montant total';

  @override
  String get selectPaymentMethod => 'Sélectionnez le mode de paiement';

  @override
  String get mobileMoney => 'Mobile Money';

  @override
  String get cardPayment => 'Paiement par carte';

  @override
  String get cardPaymentComingSoon =>
      'L\'intégration du paiement par carte arrive bientôt.';

  @override
  String get bankTransfer => 'Virement bancaire';

  @override
  String get bankTransferDetails =>
      'Les détails du virement seront envoyés à votre email.';

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String get paymentPromptMsg =>
      'Vous recevrez une demande de paiement sur ce numéro';

  @override
  String get payNow => 'Payer maintenant';

  @override
  String get verifyToPay => 'Vérifier le compte pour payer';

  @override
  String get verifyIdentity => 'Vérifier l\'identité';

  @override
  String get verifyIdentityTitle => 'Confirmez votre identité';

  @override
  String get verifyIdentitySubtitle =>
      'Nous devons vérifier votre identité avant que vous puissiez publier un trajet';

  @override
  String get fullName => 'Nom complet';

  @override
  String get fullNameHint => 'Entrez votre nom complet';

  @override
  String get nationalIdLabel => 'Numéro de carte d\'identité';

  @override
  String get idHelperText => '16 chiffres';

  @override
  String get paymentMethodsAccepted =>
      'Acceptés: MTN Mobile Money, Airtel Money';

  @override
  String get iAgreeTo => 'J\'accepte les ';

  @override
  String get termsAndConditions => 'Conditions générales';

  @override
  String get and => ' et la ';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get confirmAndContinue => 'Confirmer et continuer';

  @override
  String get secureInfoMsg => 'Vos informations sont cryptées et sécurisées';

  @override
  String get enterFullName => 'Entrez votre nom complet';

  @override
  String get enterTwoNames => 'Entrez au moins deux noms';

  @override
  String get invalidNameChars =>
      'Les noms doivent contenir uniquement des lettres';

  @override
  String get enterNationalId => 'Entrez votre carte d\'identité nationale';

  @override
  String get invalidIdLength =>
      'La carte d\'identité doit comporter 16 chiffres';

  @override
  String get invalidIdChars => 'L\'ID doit contenir uniquement des chiffres';

  @override
  String get enterPhoneNumber => 'Entrez votre numéro de téléphone';

  @override
  String get invalidPhone => 'Entrez un numéro rwandais valide';

  @override
  String get acceptTerms => 'Acceptez les conditions avant de continuer';

  @override
  String get verificationSuccess => 'Vérification réussie!';

  @override
  String get verificationSuccessMsg => 'Votre identité a été vérifiée.';

  @override
  String get continueText => 'Continuer';

  @override
  String get route => 'Itinéraire';

  @override
  String get vehicle => 'Véhicule';

  @override
  String get details => 'Détails';

  @override
  String get review => 'Révision';

  @override
  String get startingPoint => 'Point de départ';

  @override
  String get destination => 'Destination';

  @override
  String get vehicleModel => 'Modèle de véhicule';

  @override
  String get vehiclePhoto => 'Photo du véhicule';

  @override
  String get uploadCarPhoto => 'Appuyez pour télécharger une photo';

  @override
  String get departureTime => 'Heure de départ';

  @override
  String get price => 'Prix';

  @override
  String get planRoute => 'Planifiez votre itinéraire';

  @override
  String get vehicleDetails => 'Détails du véhicule';

  @override
  String get tripInfo => 'Informations sur le trajet';

  @override
  String get summary => 'Résumé';

  @override
  String get planRouteDesc => 'Où commencez-vous et où allez-vous?';

  @override
  String get vehicleDetailsDesc => 'Parlez de votre véhicule.';

  @override
  String get tripInfoDesc => 'Définissez votre horaire et vos prix.';

  @override
  String get summaryDesc => 'Vérifiez tout avant de publier.';

  @override
  String get publishRide => 'Publier le trajet';

  @override
  String get fillFormHelp => 'Remplissez le formulaire pour publier un trajet.';

  @override
  String get from => 'De';

  @override
  String get to => 'À';

  @override
  String get searchComingSoon => 'La fonction de recherche arrive bientôt!';

  @override
  String get searchFeatureDesc =>
      'Recherchez des trajets par lieu, date et prix.';

  @override
  String get emergencySOS => 'SOS d\'urgence';

  @override
  String get sosActive => 'Alerte SOS active';

  @override
  String get pressAndHold => 'Appuyez et maintenez 3 secondes';

  @override
  String get sosActivated => 'SOS activé';

  @override
  String get emergencyAlertSent => 'Alerte envoyée à:';

  @override
  String get emergencyContacts => 'Contacts d\'urgence';

  @override
  String get ishareSupport => 'Support iShare';

  @override
  String get currentTripDriver => 'Votre chauffeur actuel';

  @override
  String get liveLocationShared => 'Votre position est partagée.';

  @override
  String get call112 => 'Appeler le 112';

  @override
  String get shareLocation => 'Partager la position';

  @override
  String get shareLocationDesc => 'Votre position sera partagée par SMS.';

  @override
  String get locationSharedSuccess => 'Position partagée !';

  @override
  String get share => 'Partager';

  @override
  String get cancelTrip => 'Annuler le trajet';

  @override
  String get tripCancelRequest => 'Demande d\'annulation';

  @override
  String get police => 'Police Nationale';

  @override
  String get ambulance => 'Ambulance';

  @override
  String get fireBrigade => 'Pompiers';

  @override
  String get emergencyServices => 'Services d\'urgence';

  @override
  String get safetyTips => 'Conseils de sécurité';

  @override
  String get verifyDriver => 'Vérifier le chauffeur';

  @override
  String get verifyDriverDesc =>
      'Vérifiez toujours le nom et la photo du chauffeur.';

  @override
  String get shareTrip => 'Partager le trajet';

  @override
  String get shareTripDesc => 'Partagez les détails avec vos proches.';

  @override
  String get stayConnected => 'Restez connecté';

  @override
  String get stayConnectedDesc => 'Gardez votre téléphone chargé.';

  @override
  String get checkRatings => 'Vérifier les avis';

  @override
  String get checkRatingsDesc => 'Consultez les notes du chauffeur.';

  @override
  String get reportIssues => 'Signaler un problème';

  @override
  String get reportIssuesDesc => 'Signalez tout comportement suspect.';

  @override
  String get safetyMatters => 'Votre sécurité compte';

  @override
  String get safetyCommitment => 'iShare s\'engage pour votre sécurité.';

  @override
  String get call => 'Appeler';

  @override
  String get aboutIShare => 'À propos d\'iShare';

  @override
  String get appName => 'iShare';

  @override
  String get appTagline => 'Partagez le trajet, partagez les coûts';

  @override
  String get appDescriptionShort => 'Plateforme de covoiturage';

  @override
  String get visionTitle => '🎯 Vision';

  @override
  String get visionText => 'Révolutionner le transport en Afrique de l\'Est.';

  @override
  String get missionTitle => '🚀 Mission';

  @override
  String get missionText =>
      'Connecter conducteurs et passagers pour réduire les coûts.';

  @override
  String get problemTitle => '❓ Le problème';

  @override
  String get problemText => 'Coûts élevés, congestion et pollution.';

  @override
  String get solutionTitle => '✅ Notre solution';

  @override
  String get solutionText => 'Covoiturage fiable et abordable.';

  @override
  String get howItWorks => '📱 Comment ça marche';

  @override
  String get step1Title => 'Le chauffeur publie';

  @override
  String get step1Desc => 'Détails du trajet (heure, prix).';

  @override
  String get step2Title => 'Le passager réserve';

  @override
  String get step2Desc => 'Recherche et réservation instantanée.';

  @override
  String get step3Title => 'Voyagez ensemble';

  @override
  String get step3Desc => 'Rencontre et trajet.';

  @override
  String get step4Title => 'Noter et payer';

  @override
  String get step4Desc => 'Paiement et évaluation.';

  @override
  String get keyFeatures => '⚡ Fonctionnalités';

  @override
  String get feat1Title => 'Utilisateurs vérifiés';

  @override
  String get feat1Desc => 'Identité vérifiée.';

  @override
  String get feat2Title => 'Suivi en temps réel';

  @override
  String get feat2Desc => 'Partage de position.';

  @override
  String get feat3Title => 'Recherche intelligente';

  @override
  String get feat3Desc => 'Par ville, date ou prix.';

  @override
  String get feat4Title => 'Paiements sécurisés';

  @override
  String get feat4Desc => 'Mobile Money & Carte.';

  @override
  String get feat5Title => 'Avis';

  @override
  String get feat5Desc => 'Confiance communautaire.';

  @override
  String get feat6Title => 'SOS';

  @override
  String get feat6Desc => 'Alertes d\'urgence.';

  @override
  String get ourImpact => '🌍 Impact';

  @override
  String get impact1 => 'Réduit la congestion.';

  @override
  String get impact2 => 'Réduit l\'empreinte carbone.';

  @override
  String get impact3 => 'Économise de l\'argent.';

  @override
  String get vision2050Title => '🇷🇼 Vision 2050';

  @override
  String get vision2050Intro => 'Contribution à la Vision 2050 du Rwanda:';

  @override
  String get visionPoint1 => 'Villes intelligentes.';

  @override
  String get visionPoint2 => 'Services numériques.';

  @override
  String get visionPoint3 => 'Innovation.';

  @override
  String get longTermVision => '🚀 Vision à long terme';

  @override
  String get longTermText => 'Expansion dans la CAE.';

  @override
  String get targetCountries => 'Pays cibles:';

  @override
  String get countryRwanda => 'Rwanda';

  @override
  String get countryUganda => 'Ouganda';

  @override
  String get countryKenya => 'Kenya';

  @override
  String get countryTanzania => 'Tanzanie';

  @override
  String get countryBurundi => 'Burundi';

  @override
  String get countryDRC => 'RDC';

  @override
  String get copyrightOwner => 'iShare Rwanda Ltd';

  @override
  String get ipNotice => 'Tous droits réservés.';

  @override
  String get hereToHelp => 'Besoin d\'aide ?';

  @override
  String get reachOutMsg => 'Contactez-nous à tout moment.';

  @override
  String get findUsHere => 'Trouvez-nous';

  @override
  String get directions => 'Directions';

  @override
  String get getInTouch => 'Contact';

  @override
  String get address => 'Adresse';

  @override
  String get callUs => 'Appelez-nous';

  @override
  String get email => 'Email';

  @override
  String get hours => 'Heures';

  @override
  String get officeHours => 'Heures de bureau';

  @override
  String get monFri => 'Lun - Ven';

  @override
  String get saturday => 'Samedi';

  @override
  String get sunday => 'Dimanche';

  @override
  String get closed => 'Fermé';

  @override
  String get connectWithUs => 'Suivez-nous';

  @override
  String get haveQuestions => 'Des questions ?';

  @override
  String get sendMessageDesc => 'Envoyez un message, réponse sous 24h.';

  @override
  String get sendMessage => 'Envoyer';

  @override
  String get driverVerificationTitle => 'Vérification Chauffeur';

  @override
  String get whyVerification => 'Pourquoi ?';

  @override
  String get verificationDesc => 'Pour la sécurité de tous.';

  @override
  String get verificationSubmitted => 'Envoyé !';

  @override
  String get verificationReviewMsg =>
      'Nous examinerons votre demande sous 24-48h.';

  @override
  String get myActivity => 'Mon activité';

  @override
  String get bookedRides => 'Réservations';

  @override
  String get postedRides => 'Publications';

  @override
  String get postRide => 'Publier';

  @override
  String get noBookedRides => 'Aucune réservation';

  @override
  String get noBookedRidesDesc => 'Vos trajets apparaîtront ici.';

  @override
  String get noPostedRides => 'Aucune publication';

  @override
  String get noPostedRidesDesc => 'Publiez un trajet pour commencer.';

  @override
  String get seats => 'Sièges';

  @override
  String get upcoming => 'À venir';

  @override
  String get completed => 'Terminé';

  @override
  String get viewPassengers => 'Passagers';

  @override
  String get submitVerification => 'Soumettre';

  @override
  String get myTripsTitle => 'Mes Trajets';

  @override
  String get bookedTab => 'Réservé';

  @override
  String get offeredTab => 'Offert';

  @override
  String get noBookingsMessage => 'Aucun trajet réservé.';

  @override
  String get noOffersMessage => 'Aucun trajet publié.';

  @override
  String get welcomeTitle => 'Bienvenue sur iShare';

  @override
  String get welcomeSubtitle => 'Votre plateforme de covoiturage';

  @override
  String get statUsers => 'Utilisateurs';

  @override
  String get statTrips => 'Trajets';

  @override
  String get statRating => 'Note';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get tomorrow => 'Demain';

  @override
  String get noRidesAvailable => 'Aucun trajet disponible';

  @override
  String get onboardTitle1 => 'Voyagez en Confiance';

  @override
  String get onboardDesc1 => 'Chauffeurs vérifiés et suivi.';

  @override
  String get onboardTitle2 => 'Partagez les Frais';

  @override
  String get onboardDesc2 => 'Économisez sur vos trajets.';

  @override
  String get onboardTitle3 => 'Rapide et Fiable';

  @override
  String get onboardDesc3 => 'Trouvez un trajet en quelques minutes.';

  @override
  String get getStarted => 'Commencer';

  @override
  String get alreadyHaveAccount => 'Déjà un compte ?';

  @override
  String get login => 'Connexion';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get password => 'Mot de passe';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get orContinue => 'Ou continuer avec';

  @override
  String get newToApp => 'Nouveau ?';

  @override
  String get register => 'S\'inscrire';

  @override
  String get fillAllFields => 'Remplissez tout.';

  @override
  String get incorrectCredentials => 'Erreur d\'identification.';

  @override
  String get welcomeBack => 'Bon retour !';

  @override
  String get loginSecurely => 'Connexion sécurisée.';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get joinIshare => 'Rejoindre';

  @override
  String get firstName => 'Prénom';

  @override
  String get lastNameOptional => 'Nom (Optionnel)';

  @override
  String get emailAddress => 'Email';

  @override
  String get registerAction => 'S\'INSCRIRE';

  @override
  String get fillAllRequired => 'Champs obligatoires requis.';

  @override
  String get registrationSuccess => 'Succès ! Connectez-vous.';

  @override
  String get registrationFailed => 'Échec : ';

  @override
  String get myTicket => 'Mon Billet';

  @override
  String get tripUnavailable => 'Indisponible';

  @override
  String get bookingId => 'ID Réservation';

  @override
  String get dateLabel => 'Date';

  @override
  String get bookedStatus => 'Réservé';

  @override
  String get driverLabel => 'Chauffeur';

  @override
  String get ticketInstruction => 'Montrez ce billet au chauffeur.';

  @override
  String get tripDetails => 'Détails';

  @override
  String get estimatedEarnings => 'Gains est.';

  @override
  String get totalRevenue => 'Revenu Total';

  @override
  String get passengerManifest => 'Passagers';

  @override
  String bookedCount(int count) {
    return '$count Réservé(s)';
  }

  @override
  String get noPassengers => 'Aucun passager.';

  @override
  String get paidStatus => 'PAYÉ';

  @override
  String get cancelTripTitle => 'Annuler ?';

  @override
  String get cancelTripMessage => 'Cela annulera le trajet pour tous.';

  @override
  String get keepTrip => 'Non, garder';

  @override
  String get yesCancel => 'Oui, annuler';

  @override
  String get callingPassenger => 'Appel...';

  @override
  String get errorLoadingBookings => 'Erreur chargement : ';

  @override
  String get aboutSection => 'À propos';

  @override
  String get noBio => 'Pas de bio.';

  @override
  String joinedDate(String date) {
    return 'Rejoint le $date';
  }

  @override
  String get vehicleSection => 'Véhicule';

  @override
  String get noCarPhoto => 'Pas de photo';

  @override
  String get unknownModel => 'Inconnu';

  @override
  String get noPlateInfo => 'Pas de plaque';

  @override
  String get errorLoadProfile => 'Erreur profil';

  @override
  String get mapView => 'Carte';

  @override
  String get listView => 'Liste';

  @override
  String get shareRide => 'Partager';

  @override
  String shareMessage(String driver, String car, String from, String to) {
    return 'Je suis en route avec iShare : $from vers $to';
  }

  @override
  String get paymentAlreadyPaidTitle => 'Déjà payé';

  @override
  String get paymentAlreadyPaidMsg => 'Réservation déjà payée.';

  @override
  String get viewTrips => 'Voir trajets';

  @override
  String get approvePayment => 'Approuver';

  @override
  String get checkPhoneTitle => 'Vérifiez votre téléphone';

  @override
  String sentPromptTo(String phone) {
    return 'Envoyé au $phone.';
  }

  @override
  String get iHaveApproved => 'J\'ai approuvé';

  @override
  String get ok => 'OK';

  @override
  String get mobileMoneySubtitle => 'MTN, Airtel';

  @override
  String get cardSubtitle => 'Visa, Mastercard';

  @override
  String get bankTransferSubtitle => 'Virement';

  @override
  String get phoneHint => 'ex: 0788123456';

  @override
  String get enterPhoneError => 'Entrez le numéro';

  @override
  String get invalidPhoneError => 'Numéro invalide';

  @override
  String get rideRequests => 'Demandes';

  @override
  String get editProfile => 'Modifier profil';

  @override
  String get paymentPhoneNumber => 'Numéro de paiement';

  @override
  String get paymentInstructions => 'Envoyez le montant via Mobile Money.';

  @override
  String get subscriptionTitle => 'Abonnement';

  @override
  String get subscriptionStatus => 'Statut';

  @override
  String get trialPeriod => 'Essai';

  @override
  String get activeSubscription => 'Actif';

  @override
  String get subscriptionExpired => 'Expiré';

  @override
  String daysRemaining(int days) {
    return '$days jours';
  }

  @override
  String get pleaseRenewSubscription => 'Veuillez renouveler.';

  @override
  String get subscriptionPlans => 'Plans';

  @override
  String get perMonth => '/ mois';

  @override
  String get renewSubscription => 'Renouveler';

  @override
  String get subscribeNow => 'S\'abonner';

  @override
  String payAmount(String amount) {
    return 'Payer $amount RWF';
  }

  @override
  String trialEndsIn(int days) {
    return 'Essai finit dans $days jours.';
  }

  @override
  String get paymentViaMobileMoney => 'Paiement Mobile Money';

  @override
  String get passengerLabel => 'Passager';

  @override
  String get loginRequired => 'Connexion requise';

  @override
  String get loginToBookMessage => 'Veuillez vous connecter pour réserver.';

  @override
  String get bookingSuccessMessage => 'Réservation réussie !';

  @override
  String get requestFailed => 'Échec de la demande.';

  @override
  String get alreadyBookedError => 'Déjà réservé.';

  @override
  String get requestBooking => 'Réserver';

  @override
  String get bannerTitle => 'Connectez-vous. Partagez.';

  @override
  String get bannerSubtitle => 'Voyagez moins cher.';

  @override
  String get premiumClass => 'Premium';

  @override
  String get premiumSubtitle => 'Luxe & Vitesse';

  @override
  String get standardComfort => 'Standard';

  @override
  String get standardSubtitle => 'Fiable';

  @override
  String get economySaver => 'Éco';

  @override
  String get economySubtitle => 'Meilleur prix';

  @override
  String get noRidesFound => 'Aucun trajet';

  @override
  String get offerRideInstead => 'Proposer un trajet ?';

  @override
  String get soldOut => 'COMPLET';

  @override
  String get oneSeatLeft => '1 place !';

  @override
  String seatsCount(int count) {
    return '$count places';
  }

  @override
  String get standardCar => 'Voiture';

  @override
  String get amenityAC => 'Clim';

  @override
  String get amenityLuggage => 'Bagages';

  @override
  String get amenityNoSmoking => 'Non-fumeur';

  @override
  String get amenityMusic => 'Musique';

  @override
  String get rideRequestsTitle => 'Demandes de Trajet';

  @override
  String get noPendingRequests => 'Aucune demande en attente';

  @override
  String get caughtUpMessage => 'Tout est à jour ! Revenez plus tard.';

  @override
  String get refresh => 'Actualiser';

  @override
  String get unableToLoadRequests => 'Impossible de charger les demandes';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get requestApproved => 'Demande Approuvée';

  @override
  String get requestRejected => 'Demande Rejetée';

  @override
  String requestingSeats(int count) {
    return 'Demande $count place(s)';
  }

  @override
  String get routeInfoUnavailable => 'Info trajet indisponible';

  @override
  String get reject => 'Rejeter';

  @override
  String get acceptRequest => 'Accepter';
}
