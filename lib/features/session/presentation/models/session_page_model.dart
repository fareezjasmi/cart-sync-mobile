import 'package:cartsync/features/session/data/models/session_model.dart';

class SessionPageModel {
  final bool isLoading;
  final SessionModel? currentSession;
  final String? errorMessage;

  SessionPageModel({
    this.isLoading = false,
    this.currentSession,
    this.errorMessage,
  });

  SessionPageModel copyWith({
    bool? isLoading,
    SessionModel? currentSession,
    String? errorMessage,
  }) {
    return SessionPageModel(
      isLoading: isLoading ?? this.isLoading,
      currentSession: currentSession ?? this.currentSession,
      errorMessage: errorMessage,
    );
  }
}

class SessionPageInitial extends SessionPageModel {
  SessionPageInitial() : super();
}
