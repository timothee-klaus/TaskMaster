import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:http/http.dart' as http;

/// Crée un client HTTP injectant automatiquement les headers OAuth 2.0 Google
class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}

/// Service gérant la connexion sécurisée à Google (OAuth 2.0)
/// et offrant des méthodes pour communiquer spécifiquement avec le Google Agenda.
class GoogleCalendarService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isInitialized = false;

  calendar.CalendarApi? _calendarApi;

  bool get isConnected => _calendarApi != null;

  /// Démarre la popup d'autorisation Google et initialise l'objet CalendarApi
  Future<bool> signIn() async {
    try {
      // Configuration et initialisation (obligatoire en v7+)
      if (!_isInitialized) {
        await _googleSignIn.initialize(
          serverClientId:
              '592187326437-psvftks38oc11p0d3n3echmhi8t9dl7j.apps.googleusercontent.com',
        );
        _isInitialized = true;
      }

      await _googleSignIn.authenticate();

      // Récupération des headers via le client d'autorisation (v7+)
      final authorization = await _googleSignIn.authorizationClient
          .authorizeScopes([calendar.CalendarApi.calendarScope]);

      final authHeaders = {
        'Authorization': 'Bearer ${authorization.accessToken}',
      };

      final authClient = GoogleAuthClient(authHeaders);

      _calendarApi = calendar.CalendarApi(authClient);
      return true;
    } catch (error) {
      print('Erreur d\'authentification Google Calendar: $error');
      return false;
    }
  }

  /// Tente d'initialiser l'API à partir d'une session existante (sans popup)
  Future<bool> initializeFromExistingSignIn() async {
    try {
      if (!_isInitialized) {
        await _googleSignIn.initialize(
          serverClientId:
              '592187326437-psvftks38oc11p0d3n3echmhi8t9dl7j.apps.googleusercontent.com',
        );
        _isInitialized = true;
      }

      // On vérifie si on est déjà authentifié ou on rafraîchit le token
      final authorization = await _googleSignIn.authorizationClient
          .authorizeScopes([calendar.CalendarApi.calendarScope]);

      final authHeaders = {
        'Authorization': 'Bearer ${authorization.accessToken}',
      };

      final authClient = GoogleAuthClient(authHeaders);
      _calendarApi = calendar.CalendarApi(authClient);
      return true;
    } catch (e) {
      print('Erreur initialisation silencieuse Google Calendar: $e');
      return false;
    }
  }

  /// Déconnexion et nettoyage du client
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _calendarApi = null;
  }

  /// Crée un évènement concret dans votre véritable agenda Google
  Future<void> insertEvent({
    required String title,
    required String description,
    required DateTime startTime,
    required int durationMinutes,
  }) async {
    if (_calendarApi == null) {
      print(
        'Erreur: Impossible de créer une tâche, Google Agenda n\'est pas connecté.',
      );
      return;
    }

    final endTime = startTime.add(Duration(minutes: durationMinutes));

    // Création de l'entité native Google Event
    final event = calendar.Event(
      summary: "[TaskMaster] $title", // Pour qu'on le reconnaisse de loin !
      description: description,
      start: calendar.EventDateTime(
        dateTime: startTime,
        timeZone: 'Europe/Paris',
      ), // Fixez votre timezone si besoin
      end: calendar.EventDateTime(dateTime: endTime, timeZone: 'Europe/Paris'),
    );

    try {
      await _calendarApi!.events.insert(event, 'primary');
    } catch (e) {
      print(
        'Erreur lors de la communication avec l\'API Google Calendar insertion: $e',
      );
    }
  }

  Future<List<calendar.Event>> fetchEventsForDay(DateTime date) async {
    if (_calendarApi == null) return [];

    try {
      final startOfDay = DateTime(date.year, date.month, date.day).toUtc();
      final endOfDay = DateTime(
        date.year,
        date.month,
        date.day,
        23,
        59,
        59,
      ).toUtc();

      List<calendar.Event> allEvents = [];
      final calendarList = await _calendarApi!.calendarList.list();

      for (var cal in calendarList.items ?? []) {
        try {
          final eventsList = await _calendarApi!.events.list(
            cal.id ?? 'primary',
            timeMin: startOfDay,
            timeMax: endOfDay,
            singleEvents: true,
            orderBy: 'startTime',
          );
          if (eventsList.items != null) {
            allEvents.addAll(eventsList.items!);
          }
        } catch (e) {
          // Ignore exceptions for specific calendars that might not support certain constraints.
          print('Erreur lecture calendrier ${cal.summary}: $e');
        }
      }

      // Sort the combined events by start time
      allEvents.sort((a, b) {
        final aTime = a.start?.dateTime ?? a.start?.date ?? DateTime.utc(2100);
        final bTime = b.start?.dateTime ?? b.start?.date ?? DateTime.utc(2100);
        return aTime.compareTo(bTime);
      });

      return allEvents;
    } catch (e) {
      print('Erreur globale récupération Google Calendar items: $e');
      return [];
    }
  }
}
