import 'package:cartsync/features/session/data/models/session_model.dart';

class SessionPageModel {
  final bool isLoading;
  final SessionModel? currentSession;
  final List<SessionModel>? allSession;
  final String? errorMessage;
  final List<SessionActiveUser>? activeUser;

  SessionPageModel({this.isLoading = false, this.currentSession, this.allSession, this.errorMessage, this.activeUser});

  SessionPageModel copyWith({
    bool? isLoading,
    SessionModel? currentSession,
    List<SessionModel>? allSession,
    String? errorMessage,
    List<SessionActiveUser>? activeUser,
  }) {
    return SessionPageModel(
      isLoading: isLoading ?? this.isLoading,
      currentSession: currentSession ?? this.currentSession,
      activeUser: activeUser ?? this.activeUser,
      allSession: allSession ?? this.allSession,
      errorMessage: errorMessage,
    );
  }
}

class SessionPageInitial extends SessionPageModel {
  SessionPageInitial() : super();
}
