import 'package:cartsync/features/user/data/models/user_model.dart';

class UserPageModel {
  final bool isLoading;
  final UserModel? user;
  final String? errorMessage;

  UserPageModel({this.isLoading = false, this.user, this.errorMessage});

  UserPageModel copyWith({bool? isLoading, UserModel? user, String? errorMessage}) {
    return UserPageModel(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

class UserPageInitial extends UserPageModel {
  UserPageInitial() : super(isLoading: false);
}
