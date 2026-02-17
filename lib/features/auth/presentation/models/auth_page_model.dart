class AuthPageModel {
  final bool isLoading;
  final String? errorMessage;

  AuthPageModel({this.isLoading = false, this.errorMessage});

  AuthPageModel copyWith({bool? isLoading, String? errorMessage}) {
    return AuthPageModel(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class AuthPageInitial extends AuthPageModel {
  AuthPageInitial() : super(isLoading: false, errorMessage: null);
}
