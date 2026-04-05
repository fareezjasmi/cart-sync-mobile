class PasswordResetPageModel {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const PasswordResetPageModel({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  PasswordResetPageModel copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return PasswordResetPageModel(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
